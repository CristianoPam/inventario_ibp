import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventario_ibp/services/auth_services.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final numberPhone = TextEditingController();

  final String phoneNumber = '+5555999990000';

  enableTwoFactor(BuildContext context, bool value) async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          children: [
            const Expanded(child: Text('Autenticação 2 Fatores')),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        children: [
          const Text(
              'Informe seu número de celular para habilitar a autenticação 2 fatores:'),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: TextFormField(
              controller: numberPhone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Celular',
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(numberPhone.text),
            child: const Text('Ativar'),
          )
        ],
      ),
    );

    await ref
        .read(authServiceProvider)
        .enableTwoFactor(numberPhone.text, readSmsCode);
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
    
  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(authServiceProvider).isMultiFactorEnabled;    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        actions: [
          IconButton(
            onPressed: ref.read(authServiceProvider).logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [          
          const SizedBox(height: 7),
          const Text(
            'Cadastre um autenticador de \n verificação  em duas etapas',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          const SizedBox(
            height: 70,
            width: 300,
            child: Text(
              'Requer uma senha e uma senha de uso único (código) para fazer login na sua conta.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 150,
                child: Card(
                  margin: const EdgeInsets.all(20),
                  child: Center(
                    child: SwitchListTile(
                      value: enabled,
                      onChanged: (val) => !enabled
                          ? enableTwoFactor(context, val)
                          : ref.read(authServiceProvider).disableTwoFactor(),
                      title: Text(enabled
                          ? 'Desabilitar Dois Fatores'
                          : 'Habilitar Dois Fatores'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            child: Text(
              'Por que preciso disso?',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 130,
            width: 300,
            child: Text(
              'As senhas podem ser roubadas, especialemente se você usar a mesma senha para vários sites. Adicionar a Verificação em Duas Etapas significa que, mesmo que sua senha seja roubada, sua conta IBP permanecerá segura.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}
