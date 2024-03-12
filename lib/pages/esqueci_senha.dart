import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
final _auth = FirebaseAuth.instance;

//EsqueciSenha

class EsqueciSenha extends StatefulWidget {
  @override
  _EsqueciSenhaState createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  final _formKey = GlobalKey<FormState>();
  late String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(        
        title: const Text('Esqueci minha senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                            
                          ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _resetPassword(_email);
                  }
                },
                child: const Text('Enviar e-mail de redefinição de senha', style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail de redefinição de senha enviado'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Um erro ocorre'),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}