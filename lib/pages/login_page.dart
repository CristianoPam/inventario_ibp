import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventario_ibp/pages/validators.dart';
import 'package:inventario_ibp/services/auth_services.dart';
import 'package:validatorless/validatorless.dart';
import 'esqueci_senha.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'cpa.cristiano@gmail.com');
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();

  bool _isLogin = true;
  bool _loading = false;
  late String _title;
  late String _actionButton;
  late String _toggleButton;
  late bool _passwordConfirmVisivel = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool showLoginScreen) {
    setState(() {
      _isLogin = showLoginScreen;
      if (_isLogin) {
        _title = 'INVENTÁRIO DE \n BENS PATRIMONIAIS';
        _actionButton = 'Login';
        _toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
        _passwordConfirmVisivel = false;
        _showPassword = false;
      } else {
        _title = 'Crie sua conta';
        _actionButton = 'Cadastrar';
        _toggleButton = 'Voltar ao Login.';
        _passwordConfirmVisivel = true;
        _showPassword = false;
        _password.clear();
        
      }
    });
  }

  login() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(authServiceProvider)
          .login(_email.text, _password.text, readSmsCode);
    } on AuthException catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<String> readSmsCode() async {
    return await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: const EdgeInsets.all(24),
        title: const Text('Código de Verificação SMS'),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Código SMS',
              ),
              initialValue: '123456',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('123456'),
            child: const Text('Confirmar'),
          )
        ],
      ),
    );
  }

  registrar() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(authServiceProvider)
          .createUser(_email.text, _password.text);
    } on AuthException catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25), //50
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 200, width: 150),
                Text(_title, textAlign: TextAlign.center),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validatorless.multiple([
                      Validatorless.required('E-mail Obrigatório!'),
                      Validatorless.email('E-mail Inválido')
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: _password,
                    obscureText: _showPassword == false ? true : false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Senha',
                      suffixIcon: GestureDetector(
                        child: Icon(
                          _showPassword == false
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    validator: Validatorless.multiple([
                      Validatorless.required('Senha Obrigatório'),
                      Validatorless.min(
                          8, 'Senha precisa ter pelo menos 8 caracteres'),
                      (value) {
                        if (!contemNumeros(value.toString())) {
                          return 'Pelo menos um número';
                        } else if (!contemLetrasUppercase(value.toString())) {
                          return 'Ao menos uma letra maiúscula';
                        } else if (!contemLetrasLowercase(value.toString())) {
                          return 'Ao menos uma letra minúscula';
                        } else if (!contemCaracteresEspeciais(
                            value.toString())) {
                          return 'Pelo menos um caractere especial';
                        }
                        return null;
                      }
                    ]),
                  ),
                ),
                Visibility(
                  visible: _passwordConfirmVisivel,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 24.0),
                    child: TextFormField(
                      controller: _passwordConfirm,
                      obscureText: _showPassword == false ? true : false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Confirme Senha',
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _showPassword == false
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      validator: Validatorless.multiple([
                        Validatorless.required('Senha Obrigatório'),
                        Validatorless.min(
                            8, 'Senha precisa ter pelo menos 8 caracteres'),
                        (value) {
                          if (!contemNumeros(value.toString())) {
                            return 'Pelo menos um número';
                          } else if (!contemLetrasUppercase(value.toString())) {
                            return 'Ao menos uma letra maiúscula';
                          } else if (!contemLetrasLowercase(value.toString())) {
                            return 'Ao menos uma letra minúscula';
                          } else if (!contemCaracteresEspeciais(
                              value.toString())) {
                            return 'Pelo menos um caractere especial';
                          }
                          return null;
                        },
                        Validators.compare(
                            _password, 'Senha diferente de confirma senha')
                      ]),
                    ),
                  ),
                ),
                Visibility(
                  visible: !_passwordConfirmVisivel,
                  child: Container(
                    margin: const EdgeInsets.only(right: 23),
                    alignment: AlignmentDirectional.bottomEnd,
                    padding: const EdgeInsets.all(0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EsqueciSenha(),
                          ),
                        );
                      },
                      child: const Text('Esqueci senha'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight,
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_isLogin) {
                          login();
                        } else {
                          registrar();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (_loading)
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              const Icon(Icons.check),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  _actionButton,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setFormAction(!_isLogin),
                  child: Text(_toggleButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool contemLetrasUppercase(String input) {
    final regex = RegExp(r'[A-Z]');
    return regex.hasMatch(input);
  }

  bool contemLetrasLowercase(String input) {
    final regex = RegExp(r'[a-z]');
    return regex.hasMatch(input);
  }

  bool contemNumeros(String input) {
    final regex = RegExp(r'\d');
    return regex.hasMatch(input);
  }

  bool contemCaracteresEspeciais(String input) {
    final regex = RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]');
    return regex.hasMatch(input);
  }
}
