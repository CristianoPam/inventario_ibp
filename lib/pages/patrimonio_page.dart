import 'package:flutter/material.dart';
import 'package:inventario_ibp/Patrimonio.dart';
import 'cadastrar_page.dart';

// ignore: must_be_immutable
class PatrimonioPage extends StatelessWidget {
  Patrimonio patrimonio;

  PatrimonioPage({super.key, required this.patrimonio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            patrimonio.descricao,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NovoPatrimonioPage(patrimonio: patrimonio,),
                  ),
                );
              },
              child: const Text('Editar'),
            ),
          ],
        ),
        body: ListView(
          children: [
            Image.network(patrimonio.img ??
                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1024px-Default_pfp.svg.png', fit: BoxFit.cover,),
            Container(
             padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),                    
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                      ' Descrição: ${patrimonio.descricao} \n',  style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Raleway',fontSize: 20,),
                    ),
                    Text(
                      ' Valor: R\$ ${patrimonio.valor} ', 
                    ),
                    ],)
            ),
          ],
        ));
  }
}
