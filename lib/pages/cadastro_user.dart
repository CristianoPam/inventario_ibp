import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventario_ibp/pages/home_page.dart';
//import 'package:invetario_flutter/checagem_page.dart';


class CadastroUser extends StatefulWidget {
  const CadastroUser({super.key});

  @override
  State<CadastroUser> createState() => _CadastroUserState();
}

class _CadastroUserState extends State<CadastroUser> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  StreamSubscription? streamSubscription;

  @override
  void initState() {
    streamSubscription = _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Homepage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 219, 219),
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        title: const Text('Cadastro de Usuário'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                label: Text('Nome Completo'),
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('e-mail'),
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                label: Text('senha'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  cadastar();
                }
              },
              child: const Text(
                'Cadastrar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

//função para cadastrar novo usuário no firebaseAuth com tratamento de erro

  cadastar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      userCredential.user!.updateDisplayName(_nomeController.text);
// tratar erro de cadastro
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Crie uma senha mais forte.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este e-mail já foi cadastrado.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
