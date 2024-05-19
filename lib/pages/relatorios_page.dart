import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventario_ibp/services/pdf_service.dart';

class RelatorioPage extends StatefulWidget {
  const RelatorioPage({super.key});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  
  String title = "Relatórios Patrimôniais";
  final EmsPdfService emspdfservice = EmsPdfService();
  List _orders = [];
// Fetch order from json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString("assets/orders.json");
    final data = await json.decode(response);
    setState(() {
      _orders = data['records'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "RELATÓRIO GERAL DE PATRIMÔNIOS",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Gera o PDF ao pressionar o botão
                      final data = await emspdfservice.generateEMSPDF();
                      emspdfservice.savePdfFile("IBP Relatório", data);
                      
                    },
                    child: const Text('Gerar', textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
 
}
