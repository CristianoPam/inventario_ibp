import 'dart:ffi';
import "dart:io";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart' show OpenFile;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

String titulo = "Titulo do PDF";

class EmsPdfService {
  Future<Uint8List> generateEMSPDF() async {
    final pdf = pw.Document();
    List<pw.Widget> widgets = [];

    final image =
        (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List();
    final logoArea = pw.Container(
        padding: const pw.EdgeInsets.all(10.0),
        height: 60.0,
        color: PdfColor.fromHex("#aaddfbd9"),
        child:
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Image(pw.MemoryImage(image),
              width: 40, height: 40, fit: pw.BoxFit.cover),
          pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10.0),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Relatório",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Geral de Patrimônios",
                        style: pw.TextStyle(
                            color: PdfColor.fromHex("#666"), fontSize: 10.0))
                  ]))
        ]));

    final gap30 = pw.SizedBox(height: 30);

    final int quantidadePatrimonio = await countPatrimonios();
    final double valorTotalPatrimonio = await sumPatrimoniosValue();

    final balanceArea =
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Expanded(
          child: pw.Container(
              padding: const pw.EdgeInsets.all(10.0),
              height: 70.0,
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromHex("#f0f0f0"))),
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Quantidade Patrimônio",
                        style: pw.TextStyle(
                            color: PdfColor.fromHex("#666"), fontSize: 10.0)),
                    pw.Text(quantidadePatrimonio.toString(),
                        style: pw.TextStyle(
                            color: PdfColors.green,
                            fontWeight: pw.FontWeight.bold)),
                  ]))),
      pw.Expanded(
          child: pw.Container(
              padding: const pw.EdgeInsets.all(10.0),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromHex("#f0f0f0"))),
              height: 70.0,
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Valor total Patrimônio",
                        style: pw.TextStyle(
                            color: PdfColor.fromHex("#666"), fontSize: 10.0)),
                    pw.Text(valorTotalPatrimonio.toString(),
                        style: pw.TextStyle(
                            color: PdfColors.red,
                            fontWeight: pw.FontWeight.bold))
                  ]))),
    ]);

    widgets.add(logoArea);
    widgets.add(gap30);
    widgets.add(balanceArea);
    widgets.add(gap30);

    final tableData = await fetchPatrimonios();
    widgets.add(buildTable(tableData));

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return widgets;
        }));

    return pdf.save();
  }

  Future<int> countPatrimonios() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('patrimonios').get();
    return snapshot.size;
  }

Future<double> sumPatrimoniosValue() async {
  try {
    // Obtém os dados da coleção 'patrimonios' do Firestore
    final snapshot = await FirebaseFirestore.instance.collection('patrimonios').get();
    
    double totalValue = 0.00;

    // Itera sobre cada documento na coleção
    for (var doc in snapshot.docs) {
      // Verifica se o campo 'valor' existe e não é nulo
      if (doc.data().containsKey('valor') && doc.data()['valor'] != null) {
        try {
          // Tenta converter a string para double
          final valorString = doc.data()['valor'];
          final valor = double.parse(valorString);
          totalValue += valor;
        } catch (e) {
          // Se a conversão falhar, loga o erro
          print('Erro ao converter o valor para double: ${doc.data()['valor']}, erro: $e');
        }
      } else {
        // Se o campo 'valor' não existe ou é nulo, loga uma mensagem de aviso
        print('Campo "valor" ausente ou nulo no documento: ${doc.id}');
      }
    }
    
    return totalValue;
  } catch (e) {
    // Captura e loga qualquer erro que ocorrer durante a execução
    print('Erro ao obter dados do Firestore: $e');
    return 0.0;
  }
}



  Future<List<Map<String, dynamic>>> fetchPatrimonios() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('patrimonios').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  pw.Table buildTable(List<Map<String, dynamic>> data) {
    List<pw.TableRow> rows = [];

    for (var patrimonio in data) {
      rows.add(pw.TableRow(children: <pw.Widget>[
        pw.Padding(
          padding: const pw.EdgeInsets.all(10.0),
          child: pw.Text(patrimonio['cod'] ?? '',
              textAlign: pw.TextAlign.left,
              style: const pw.TextStyle(fontSize: 10.0)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10.0),
          child: pw.Text(patrimonio['descricao'] ?? '',
              textAlign: pw.TextAlign.left,
              style: const pw.TextStyle(fontSize: 10.0)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10.0),
          child: pw.Text(patrimonio['nSerie'] ?? '',
              textAlign: pw.TextAlign.left,
              style: const pw.TextStyle(fontSize: 10.0)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10.0),
          child: pw.Text(patrimonio['valor']?.toString() ?? '',
              textAlign: pw.TextAlign.left,
              style: const pw.TextStyle(fontSize: 10.0)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10.0),
          child: pw.Text(patrimonio['localizacao'] ?? '',
              textAlign: pw.TextAlign.left,
              style: const pw.TextStyle(fontSize: 10.0)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10.0),
          child: pw.Text(patrimonio['observacoes'] ?? '',
              textAlign: pw.TextAlign.left,
              style: const pw.TextStyle(fontSize: 10.0)),
        ),
      ]));
    }

    return pw.Table(
        border: pw.TableBorder.all(color: PdfColor.fromHex("#f0f0f0")),
        columnWidths: const <int, pw.TableColumnWidth>{
          0: pw.FixedColumnWidth(80),
          1: pw.FixedColumnWidth(120),
          2: pw.FixedColumnWidth(80),
          3: pw.FixedColumnWidth(80),
          4: pw.FixedColumnWidth(80),
          5: pw.FixedColumnWidth(120),
        },
        children: <pw.TableRow>[
          pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColor.fromHex("#009EFB")),
              children: <pw.Widget>[
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Text("Código",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Text("Descrição",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Text("Número/ \n Série",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Text("Valor",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Text("Local",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10.0),
                  child: pw.Text("Observações",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                ),
              ]),
          ...rows
        ]);
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFile.open(filePath);
  }
}
