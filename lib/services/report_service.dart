import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class ReportService {
  Future<Uint8List> generateStationReport(String stationName, Map<String, dynamic> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Telecom AI - Station Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Station: $stationName'),
              pw.Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text('KPI Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['KPI', 'Value'],
                  ['Availability', '${data['availability']}%'],
                  ['CSSR', '${data['cssr']}%'],
                  ['CDR', '${data['cdr']}%'],
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
