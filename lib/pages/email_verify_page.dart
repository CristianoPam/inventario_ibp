import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventario_ibp/services/auth_services.dart';


class EmailVerifyPage extends StatelessWidget {
  const EmailVerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mark_email_unread_outlined,
              size: 72,
              color: Colors.deepPurple.shade100,
            ),
            const Text('Aguardando confirmação do email'),
            Consumer(builder: (context, ref, _) {
              return OutlinedButton(
                onPressed: ref.read(authServiceProvider).userConfirmedEmail,
                child: const Text('Já confirmei!'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
