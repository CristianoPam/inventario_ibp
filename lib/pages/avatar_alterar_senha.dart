import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventario_ibp/model/password_validation.dart';
import 'package:validatorless/validatorless.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  final _avatar = Image.asset('assets/images/avatar.png');
  final _name = 'Cristiano Pereira Alves';
  String _email = '';
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  var passValidator = PassValidarion();
  bool _showPassword = false;

  changePassword({email, oldPassword, newPassword}) async {
    var cred =
        EmailAuthProvider.credential(email: email, password: oldPassword);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newPassword);
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  @override
  initState() {
    super.initState();
    setState(() {
      User? usuario = currentUser;
      //nome = usuario!.displayName.toString();
      _email = usuario!.email.toString();
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
                // Avatar
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

                // Current Password
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 24.0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    child: TextFormField(
                      controller: _currentPasswordController,
                      obscureText: _showPassword == false ? true : false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Senha Atual',
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _showPassword == false
                                ? Icons.visibility_off
                                : Icons.visibility,
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

                // New Password
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 24.0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    child: TextFormField(
                      controller: _newPasswordController,
                      obscureText: _showPassword == false ? true : false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Nova Senha',
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _showPassword == false
                                ? Icons.visibility_off
                                : Icons.visibility,
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
                        Validatorless.required('Nova senha Obrigatória'),
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

                // CHANGE BUTTON
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await changePassword(
                          email: _email,
                          oldPassword: _currentPasswordController.text,
                          newPassword: _newPasswordController.text,
                        );
                        if (kDebugMode) {
                          print("Password redefinido!");
                        }
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (false)
                          // ignore: dead_code
                          ? [
                              Padding(
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
                          // ignore: dead_code
                          : [
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  'Alterar Senha',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
