import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

enum AuthStatus {
  signedOut,
  signedIn,
  emailVerifyPending,
}

final authServiceProvider = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthStatus status = AuthStatus.signedOut;
  User? userData;
  bool isMultiFactorEnabled = false;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      userData = user;
      _checkUserStatus();
      _checkMultiFactorStatus();
      notifyListeners();
    });
  }

  _checkMultiFactorStatus() async {
    if (userData != null) {
      final list = await userData!.multiFactor.getEnrolledFactors();
      isMultiFactorEnabled = list.isNotEmpty;
      notifyListeners();
    }
  }

  _getUser() {
    userData = _auth.currentUser;
    _checkUserStatus();
    _checkMultiFactorStatus();
    notifyListeners();
  }

  userConfirmedEmail() async {
    await logout();
  }

  _checkUserStatus() async {
    if (userData != null) {
      if (userData!.emailVerified == false) {
        status = AuthStatus.emailVerifyPending;
      } else {
        status = AuthStatus.signedIn;
      }
    } else {
      status = AuthStatus.signedOut;
    }
  }

  createUser(String email, String pass) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      await _getUser();
      await userData!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    }
  }

  login(String email, String pass, Future<String> Function() getSmsCode) async {
    // Se o 2FA estiver habilitado, após fazer o login irá retornar uma exceção
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      await _getUser();
    }
    // Essa Exception é necessário e traz o resolver do 2FA
    on FirebaseAuthMultiFactorException catch (e) {
      _verifyTwoFactor(e, getSmsCode);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      }
    }
  }

  _verifyTwoFactor(FirebaseAuthMultiFactorException e, Future<String> Function() getSmsCode) async {
    // Caso o usuário tenha mais de um 2FA, é necessário solicitar ao usuário
    // Aqui está o primeiro, pois está apenas por SMS
    final firstHint = e.resolver.hints.first;
    if (firstHint is! PhoneMultiFactorInfo) {
      return;
    }
    await _auth.verifyPhoneNumber(
      multiFactorSession: e.resolver.session,
      multiFactorInfo: firstHint,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Se automático, loga com a credencial e o resolver 2FA
        _signInWithCredential(credential, e.resolver);
      },
      verificationFailed: (_) {},
      codeSent: (String verificationId, int? resendToken) async {
        // Se manual, valida o SMS code
        final smsCode = await getSmsCode();

        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        // E, então, loga com a credencial e o resolver 2FA
        _signInWithCredential(credential, e.resolver);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  logout() async {
    await _auth.signOut();
    userData = null;
  }

  _signInWithCredential(PhoneAuthCredential credential, MultiFactorResolver resolver) async {
    try {
      await resolver.resolveSignIn(
        PhoneMultiFactorGenerator.getAssertion(credential),
      );
      _getUser();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }

  _reauthenticate() async {
    // TODO: Redirecionar para o login ou Alert p/ senha
    try {
      final userCreds = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: '123456',
      );
      // É necessário usar o método reauthenticate para confirmar a alteração.
      await _auth.currentUser!.reauthenticateWithCredential(userCreds);
    } on FirebaseAuthMultiFactorException catch (e) {
      // Se o usuário tenta desabilitar o 2FA, é necessário autorização 2FA
      // TODO: é necessário fazer o prompt para verificar o código SMS
      // Aqui está fixo apenas para teste
      await _verifyTwoFactor(e, () => Future.value('123456'));
      _getUser();
    }
  }

  enableTwoFactor(String phoneNumber, Future<String> Function() getSmsCode) async {
    // 0 - É necessário reaunteticar o usuário
    await _reauthenticate();

    // 1 - Recuperar a sessão do usuário
    final session = await userData?.multiFactor.getSession();

    // 2 - Verificar o número
    await _auth.verifyPhoneNumber(
      multiFactorSession: session,
      phoneNumber: phoneNumber,
      // 3.1 - Se a verificação do SMS for automática
      verificationCompleted: (credential) async {
        await _addMultiFactorCredential(credential);
        await userData!.updatePhoneNumber(credential);
      },
      verificationFailed: (_) {},
      // 3.2. Se a verificação for manual
      codeSent: (String verificationId, int? resendToken) async {
        // 3.3 - Ler o código SMS
        final smsCode = await getSmsCode();
        // 4 - Habilitar o Phone Auth
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        // 5. Atribuir o número à credencial do usuário
        await _addMultiFactorCredential(credential);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  disableTwoFactor() async {
    try {
      await _reauthenticate();
      final factors = await userData!.multiFactor.getEnrolledFactors();
      await userData!.multiFactor.unenroll(multiFactorInfo: factors.first);
    } on FirebaseAuthMultiFactorException catch (e) {
      await _verifyTwoFactor(e, () => Future.value('123456'));
      _getUser();
    }
  }

  _addMultiFactorCredential(PhoneAuthCredential credential) async {
    try {
      await userData?.multiFactor.enroll(
        PhoneMultiFactorGenerator.getAssertion(credential),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }
}
