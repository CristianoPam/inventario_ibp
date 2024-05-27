import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventario_ibp/services/pdf_service.dart';

class RelatoriosPages extends StatefulWidget {
  const RelatoriosPages({super.key});

  @override
  _RelatoriosPagesState createState() => _RelatoriosPagesState();
}

class _RelatoriosPagesState extends State<RelatoriosPages> {
  Map<String, int> _data = {
    'Informática': 0,
    'Maquinário': 0,
    'Veículos': 0,
    'Móveis Externos': 0,
    'Diversos': 0,
  };

  final EmsPdfService emspdfservice = EmsPdfService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('patrimonios').get();

      Map<String, int> tempData = {
        'Informática': 0,
        'Maquinário': 0,
        'Veículos': 0,
        'Móveis Externos': 0,
        'Diversos': 0,
      };

      for (var document in snapshot.docs) {
        var data = document.data() as Map<String, dynamic>;
        if (tempData.containsKey(data['gBens'])) {
          tempData[data['gBens']] = (tempData[data['gBens']] ?? 0) + 1;
        }
      }

      setState(() {
        _data = tempData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: const Text('Relatórios'),
      ),
      body: Center(
        child: _data.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Relatório Geral',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 100),
                    AspectRatio(
                      aspectRatio: 1.65,
                      child: PieChart(
                        PieChartData(
<<<<<<< HEAD
                          sectionsSpace: 0, // Remover espaço entre as fatias
=======
                          sectionsSpace: 0, // Remover espaço entre as fatias                          
>>>>>>> ad85970ab3ae7c7fa3d8a9dc5602cc643b086d2f
                          sections: _buildPieChartSections(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 90.0),
                    SizedBox(
                      height: 40,
                      width: 130,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F5F98),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20), // Adiciona padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Define a borda arredondada
                          ),
                        ),
                        onPressed: () async {
                          // Gera o PDF ao pressionar o botão
                          final data = await emspdfservice.generateEMSPDF();
                          emspdfservice.savePdfFile("IBP Relatório", data);
                        },
                        child: const Text(
                          'GERAR PDF',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100.0),
                  ],
                ),
              ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final total = _data.values.reduce((a, b) => a + b);
    
    if (total == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: 'Sem dados',
          radius: 50,
          titlePositionPercentageOffset: 1.75,
          titleStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ];
    }

    return _data.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: _getColor(entry.key),
<<<<<<< HEAD
        value: percentage,
        title: '${entry.key} \n (${percentage.toStringAsFixed(1)}%)',
        radius: 50,
        titlePositionPercentageOffset: 1.75, // Colocar a legenda fora da fatia
=======
        value: entry.value.toDouble() ,
        title: '${entry.key} \n (${entry.value})',
        radius: 50,
        titlePositionPercentageOffset: 1.75, // Colocar a legenda fora da fatia              
>>>>>>> ad85970ab3ae7c7fa3d8a9dc5602cc643b086d2f
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black87,

        ),
      );
    }).toList();
  }

  Color _getColor(String key) {
    switch (key) {
      case 'Informática':
        return const Color(0xFF2D8BBA); // Azul específico 1
      case 'Maquinário':
        return const Color(0xFF41B8D5); // Azul específico 2
      case 'Veículos':
        return const Color(0xFF2F5F98); // Azul específico 3
      case 'Móveis Externos':
        return const Color(0xFF31356E); // Azul específico 4
      case 'Diversos':
        return const Color(0xFF90CAF9); // Azul claro padrão (Blue 200)
      default:
        return const Color(0xFFB0BEC5); // Azul acinzentado (Blue Grey 200)
    }
  }
}
