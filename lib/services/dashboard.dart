import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class PatrimoniosPieChart extends StatefulWidget {
  const PatrimoniosPieChart({super.key});

  @override
  _PatrimoniosPieChartState createState() => _PatrimoniosPieChartState();
}

class _PatrimoniosPieChartState extends State<PatrimoniosPieChart> {
  Map<String, int> _data = {
    'Informática': 0,
    'Maquinário': 0,
    'Veículos': 0,
    'Móveis Externos': 0,
    'Diversos': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('patrimonios')
          .get();

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
        title: const Text('Relatórios'),
      ),
      body: Center(
        child: _data.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Distribuição dos \n Patrimônios por Grupo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,                        
                      ),
                                          ),
                    const SizedBox(height: 30),
                    AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieChartSections(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return _data.entries.map((entry) {
      return PieChartSectionData(
        color: _getColor(entry.key),
        value: entry.value.toDouble(),
        title: '${entry.key} (${entry.value})',
        radius: 85,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    }).toList();
  }

  Color _getColor(String key) {
    switch (key) {
      case 'Informática':
        return Colors.blue;
      case 'Maquinário':
        return Colors.green;
      case 'Veículos':
        return Colors.red;
      case 'Móveis Externos':
        return Colors.yellow;
      case 'Diversos':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
