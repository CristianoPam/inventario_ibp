import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventario_ibp/Patrimonio.dart';
import 'package:inventario_ibp/pages/patrimonio_page.dart';
import 'cadastrar_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool saved = false;

  // final _firebaseAuth = FirebaseAuth.instance;

  // void signUserOut() async {
  //   await _firebaseAuth.signOut();
  //   context.go('/login');
  // }

  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();

    super.dispose();
  }

  final Stream<QuerySnapshot> patrimonios =
      FirebaseFirestore.instance.collection('patrimonios').snapshots();

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => NovoPatrimonioPage()));
        },
        label: const Text('Adicionar'),
        icon: const Icon(Icons.add_task),
      ),
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 50, width: 50),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: patrimonios,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erro ao buscar dados');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Patrimonio patrimonio = Patrimonio.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return ListTile(
                  tileColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatrimonioPage(patrimonio: patrimonio),
                      ),
                    );
                  },
                  leading: Container(
                    width: 90,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          patrimonio.img ??
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1024px-Default_pfp.svg.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: Text(patrimonio.descricao),
                  subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(patrimonio.cod),
                        Text('R\$ ${patrimonio.valor}'),
                      ]),
                );
              });
        },
      ),
    );
  }
}
