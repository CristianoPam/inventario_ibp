import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventario_ibp/model/password_validation.dart';
import 'package:validatorless/validatorless.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final auth = FirebaseAuth.instance;
  User? currentUser;
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  var passValidator = PassValidarion();
  bool _showPassword = false;
  bool _loading = false;
  String _email = '';
  String _name = '';
  final _avatar = Image.asset('assets/images/avatar.png');

  @override
  void initState() {
    super.initState();
    currentUser = auth.currentUser;
    _email = currentUser!.email.toString();
    
    if (_email.contains('cpa.cristiano@gmail.com') ) {
      _name = 'Cristiano Pereira Alves';
    } else {
      _name = 'Thays Martines ';
    }
    
  }

  Future<void> changePassword(
      {required String email,
      required String oldPassword,
      required String newPassword}) async {
    setState(() {
      _loading = true;
    });

    try {
      final cred =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await currentUser!.reauthenticateWithCredential(cred);
      await currentUser!.updatePassword(newPassword);
      if (kDebugMode) {
        print("Password redefinido!");
      }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso')));
      _currentPasswordController.clear();
      _newPasswordController.clear();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao alterar a senha')));
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar, Name, Email - unchanged
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _avatar.image,
                ),

                // Name
                const SizedBox(height: 20),
                Text(
                  _name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Email
                const SizedBox(height: 10),
                Text(
                  _email,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 60),

                // Current Password
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 24.0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    child: TextFormField(
                      controller: _currentPasswordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Senha Atual',
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF767676),
                          ),
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor digite sua senha atual';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // New Password
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 24.0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    child: TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Nova Senha',
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF767676),
                          ),
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      validator: Validatorless.multiple([
                        Validatorless.required('Nova senha obrigatória'),
                        Validatorless.min(
                            8, 'Senha precisa ter pelo menos 8 caracteres'),
                        (value) {
                          if (!passValidator.contemNumeros(value.toString())) {
                            return 'Pelo menos um número';
                          } else if (!passValidator
                              .contemLetrasUppercase(value.toString())) {
                            return 'Ao menos uma letra maiúscula';
                          } else if (!passValidator
                              .contemLetrasLowercase(value.toString())) {
                            return 'Ao menos uma letra minúscula';
                          } else if (!passValidator
                              .contemCaracteresEspeciais(value.toString())) {
                            return 'Pelo menos um caractere especial';
                          }
                          return null;
                        }
                      ]),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CHANGE BUTTON
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await changePassword(
                                  email: currentUser!.email!,
                                  oldPassword: _currentPasswordController.text,
                                  newPassword: _newPasswordController.text,
                                );
                              }
                            },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Alterar Senha',
                                    style: TextStyle(fontSize: 20)),
                          ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
