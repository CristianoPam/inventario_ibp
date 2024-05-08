import "dart:io";
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
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
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
        ],
      ),
    );

    final gap30 = pw.SizedBox(height: 30); //criando um espaçamento no pdf
    final balanceArea =
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Expanded(
        child: pw.Container(
            padding: const pw.EdgeInsets.all(10.0),
            height: 70.0,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColor.fromHex("#f0f0f0")),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Quantidade Patrimônio",
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#666"), fontSize: 10.0)),
                pw.Text("9999999",
                    style: pw.TextStyle(
                        color: PdfColors.green,
                        fontWeight: pw.FontWeight.bold)),
              ],
            )),
      ),
      pw.Expanded(
        child: pw.Container(
            padding: const pw.EdgeInsets.all(10.0),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColor.fromHex("#f0f0f0")),
            ), // pw.BoxDecoration
            height: 70.0,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Valor total Patrimônio",
                    style: pw.TextStyle(
                        color: PdfColor.fromHex("#666"), fontSize: 10.0)),
                pw.Text("9999999",
                    style: pw.TextStyle(
                        color: PdfColors.red, fontWeight: pw.FontWeight.bold))
              ],
            )),
      ),
    ]);

    widgets.add(logoArea);
    widgets.add(gap30);
    widgets.add(balanceArea);
    widgets.add(gap30);
    widgets.add(table());

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return widgets;
        }));

    return pdf.save();
  }

  pw.Table table() {
    List<pw.TableRow> rows = [];

    for (int i = 0; i < 5; i++) {
      rows.add(pw.TableRow(
        children: <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Text("12-05-2024",
                textAlign: pw.TextAlign.left,
                style: const pw.TextStyle(fontSize: 10.0)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Text("sample",
                textAlign: pw.TextAlign.left,
                style: const pw.TextStyle(fontSize: 10.0)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Text("COD".toUpperCase(),
                textAlign: pw.TextAlign.left,
                style: const pw.TextStyle(fontSize: 10.0)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Text("9.093",
                textAlign: pw.TextAlign.left,
                style: const pw.TextStyle(fontSize: 10.0)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Text("98989",
                textAlign: pw.TextAlign.left,
                style: const pw.TextStyle(fontSize: 10.0)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Text("9",
                textAlign: pw.TextAlign.left,
                style: const pw.TextStyle(fontSize: 10.0)),
          ),
        ],
      ));
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColor.fromHex("#f0f0f0")),
      columnWidths: const <int, pw.TableColumnWidth>{
        0: pw.FixedColumnWidth(100),
        1: pw.FixedColumnWidth(80),
        2: pw.FixedColumnWidth(80),
        6: pw.FixedColumnWidth(90),
        8: pw.FixedColumnWidth(100),
      },
      children: <pw.TableRow>[
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromHex("#009EFB")),
          children: <pw.Widget>[
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Text("Nome",
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                      fontSize: 10.0,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold)),
            ),
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
              child: pw.Text("Descrição",
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                      fontSize: 10.0,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        ...rows
      ],
    );
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFile.open(filePath);
  }
}
