import 'package:flutter/material.dart';
import 'package:inventario_ibp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvatarCard extends StatefulWidget {
  const AvatarCard({
    super.key,
  });

  @override
  State<AvatarCard> createState() => _AvatarCardState();
}

class _AvatarCardState extends State<AvatarCard> {
  final _firebaseAuth = FirebaseAuth.instance;

  String nome = 'Nome do Usuário';
  String email = '';

  @override
  initState() {
    super.initState();
    setState(() {
      User? usuario = _firebaseAuth.currentUser;
      //nome = usuario!.displayName.toString();
      email = usuario!.email.toString();    
      
    });
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.person_outline, size: 50),
        const SizedBox(width: 1),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nome,
              style: const TextStyle(
                fontSize: kbigFontSize,
                fontWeight: FontWeight.bold,
                color: kprimaryColor,
              ),
            ),
            Text(
              email,
              style: TextStyle(
                fontSize: ksmallFontSize,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        )
      ],
    );
  }
/*
  pegarUsuario() async {
    User? usuario = _firebaseAuth.currentUser;
    if (usuario != null) {
      setState(() {
        nome = usuario.displayName!;
        email = usuario.email!;
        
      });
    }
  } */
}
