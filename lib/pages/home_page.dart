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
  late Stream<QuerySnapshot> patrimonios;

  StreamSubscription? streamSubscription;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    patrimonios =
        FirebaseFirestore.instance.collection('patrimonios').snapshots();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 10.0,
              shadowColor: Colors.blue,
              borderRadius: BorderRadius.circular(15),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    patrimonios = FirebaseFirestore.instance
                        .collection('patrimonios')                        
                        .where('descricao', isGreaterThanOrEqualTo: value)
                        .where('descricao', isLessThan: '${value}z')                                                
                        .snapshots();
                  });
                  // Implemente a lógica de filtragem aqui
                },
                decoration: const InputDecoration(
                  labelText: 'Pesquisar',
                  hintText: 'Pesquisar...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
        ),
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
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
