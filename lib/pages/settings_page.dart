import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventario_ibp/constants.dart';
import 'package:inventario_ibp/pages/two_factors.dart';
import 'package:inventario_ibp/widget/avatar_card.dart';
//import 'package:inventario_ibp/widget/setting_tile.dart';
import 'package:inventario_ibp/widget/support_card.dart';
import 'package:inventario_ibp/widget/under_construction.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _firebaseAuth = FirebaseAuth.instance;

  void signUserOut() async {
    await _firebaseAuth.signOut();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AvatarCard(),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Column(
                  children: [
                    // DADOS PESSOAIS
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: klightContentColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            child: const Icon(CupertinoIcons.person_fill,
                                color: kprimaryColor),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UnderConstruction(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Dados Pessoais',
                          style: TextStyle(
                            color: kprimaryColor,
                            fontSize: ksmallFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: Icon(
                            CupertinoIcons.chevron_forward,
                            color: Colors.grey.shade600,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UnderConstruction(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // AUTENTICAÇÃO MULTIFATOR
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: klightContentColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            child: const Icon(CupertinoIcons.settings,
                                color: kprimaryColor),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TwoFactors(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Autenticação Multifator',
                          style: TextStyle(
                            color: kprimaryColor,
                            fontSize: ksmallFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: Icon(
                            CupertinoIcons.chevron_forward,
                            color: Colors.grey.shade600,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TwoFactors(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // BIOMETRIA
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: klightContentColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            child: const Icon(CupertinoIcons.hand_raised_slash,
                                color: kprimaryColor),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UnderConstruction(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Biometria',
                          style: TextStyle(
                            color: kprimaryColor,
                            fontSize: ksmallFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: Icon(
                            CupertinoIcons.chevron_forward,
                            color: Colors.grey.shade600,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UnderConstruction(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // SAIR DO APLICATIVO
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: klightContentColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            child: const Icon(
                                IconData(0xf031, fontFamily: 'MaterialIcons')),
                            onTap: () {
                             _dialogBuilderExit; 
                              
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Sair',
                          style: TextStyle(
                            color: kprimaryColor,
                            fontSize: ksmallFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: Icon(
                            CupertinoIcons.chevron_forward,
                            color: Colors.grey.shade600,
                          ),
                          onTap: () {
                            //carregar para sair
                            _dialogBuilderExit;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const SupportCard(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UnderConstruction(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // verificar o contexto para qual patromônio vai ser excluido
  Future<void> _dialogBuilderExit(
      {required BuildContext context, required String id}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Patrimônio'),
          content: const Text(
            'Ao fazer isso, não será mais possível restaurar o Patrimonio!',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Apagar'),
              onPressed: () {
               
              },
            ),
          ],
        );
      },
    );
  }
}
