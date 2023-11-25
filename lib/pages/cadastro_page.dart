//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:invetario_flutter/pages/home_page.dart';
//import 'package:firebase_database/firebase_database.dart';

//import 'cadastro_widget.dart';
import 'consulta_widget.dart';

// ignore: must_be_immutable
class CadastroPatrimonio extends StatefulWidget {
  CadastroPatrimonio({super.key});

  @override
  State<CadastroPatrimonio> createState() => _CadastroPatrimonioState();
}

class _CadastroPatrimonioState extends State<CadastroPatrimonio> {
  final List<Widget> _pages = [
    Container(),
    const Consulta(),
  ];

  final List<Widget> _tabs = const [
    Text('Cadastro'),
    Text('Consulta'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _pages.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[200],
          bottom: TabBar(tabs: _tabs),
        ),
        body: TabBarView(children: _pages),
      ),
    );
  }
}
