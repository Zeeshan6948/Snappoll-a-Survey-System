import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../global/global_variables.dart';

Future<void> saveCSVToDownloads(int index, List<List<dynamic>> csvData) async {
  // Generate the CSV string
  String csvString =
      const ListToCsvConverter(fieldDelimiter: ";").convert(csvData);
  String filePath = '';
  // Get the document directory using path_provider package
  if (kIsWeb) {
    // For Web: Use dart:html to trigger a download
    final bytes = Uint8List.fromList(csvString.codeUnits);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create a hidden anchor element and trigger the download
    html.AnchorElement(href: url)
      ..setAttribute("download",
          "${GlobalVariables.templatesList[index].reference.id}.csv")
      ..click();

    // Clean up the URL object
    html.Url.revokeObjectUrl(url);

    print('CSV file downloaded for Web.');
  }
  print('CSV file saved to: $filePath');
}
