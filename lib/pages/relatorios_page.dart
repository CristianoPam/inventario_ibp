import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:inventario_ibp/services/dashboard.dart';
import 'package:inventario_ibp/services/pdf_service.dart';

class RelatorioPage extends StatefulWidget {
  const RelatorioPage({super.key});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  String title = "Relatórios Patrimoniais";
  final EmsPdfService emspdfservice = EmsPdfService();
  // ignore: unused_field
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            ReportCard(
              title: "RELATÓRIO GERAL",
              icon: Icons.picture_as_pdf,
              onPressed: () async {
                // Gera o PDF ao pressionar o botão
                final data = await emspdfservice.generateEMSPDF();
                emspdfservice.savePdfFile("IBP Relatório", data);
              },
            ),
            const SizedBox(height: 20.0),
            ReportCard(
              title: "PATRIMÔNIOS POR GRUPO",
              icon: Icons.pie_chart,
              onPressed: () {
                // Gera o Gráfico ao pressionar o botão
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatrimoniosPieChart(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const ReportCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40.0, color: Theme.of(context).primaryColor),
            const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Gerar'),
            ),
          ],
        ),
      ),
    );
  }
}
