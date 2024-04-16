import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventario_ibp/patrimonio.dart';
import 'cadastrar_patrimonio.dart';

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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,      
        children: [      
          
          Column(
            children: [
              const SizedBox(height: 10,),
              Image.network(
                patrimonio.img ??
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1024px-Default_pfp.svg.png',
                fit: 
                BoxFit.cover,                                  
              ),

              const SizedBox(height: 20,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(

                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Descrição: ${patrimonio.descricao} \n',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ' Valor: R\$ ${patrimonio.valor} ',
                    ),
                  ),
                ],
              ),
            ],            
          ),

          Column(                       
            children: [
              Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton.extended(                      
                            onPressed: () {
                              // Adicione a lógica desejada para o botão de editar aqui                    
                            Navigator.push(
                            context,
                              MaterialPageRoute(
                              builder: (_) => NovoPatrimonioPage(
                                patrimonio: patrimonio,
                              ),
                            ),
                          );                  
                            },
                            tooltip: 'Editar',
                            heroTag: null, // Defina como null para evitar um aviso
                            backgroundColor: Colors.transparent,                      
                            elevation: 0,                      
                            foregroundColor: const Color(0xFF767676),
                            label: const Text('Editar'),
                            icon: const Icon(Icons.edit),
                          ),
              
                          FloatingActionButton.extended(                            
                            onPressed: () {
                              // Adicione a lógica desejada para o botão de excluir aqui
                              _dialogBuilder(
                                   context: context, id: patrimonio.cod);                  
                            },                            
                            tooltip: 'Excluir',
                            heroTag: null, // Defina como null para evitar um aviso
                            backgroundColor: Colors.transparent,                      
                            elevation: 0,                      
                            foregroundColor: const Color(0xFF767676), 
                            label: const Text('Excluir'),                                                                            
                            icon: const Icon(Icons.delete,),                                                        
                          ),]),
            ],
          )


        ],
      ),
    );
  }

// verificar o contexto para qual patromônio vai ser excluido
  Future<void> _dialogBuilder(
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
                FirebaseFirestore.instance
                    .collection('patrimonios')
                    .doc(id)
                    .delete()
                    .then((value) {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
