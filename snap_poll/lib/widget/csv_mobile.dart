import 'package:csv/csv.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../global/global_variables.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveCSVToDownloads(int index, List<List<dynamic>> csvData) async {
  // Generate the CSV string
  String csvString =
      const ListToCsvConverter(fieldDelimiter: ";").convert(csvData);
  String filePath = '';
  // Get the document directory using path_provider package
  Directory directory = Directory("");
  if (!kIsWeb) {
    // Redirects it to download folder in android
    directory = Directory("/storage/emulated/0/Download");

    // Create the CSV file path
    // if(GlobalVariables.roleType == 'maintainer')
    //   filePath = '${directory.path}/${maintainersList[index].reference.id}.csv';
    // else
    filePath =
        '${directory.path}/${GlobalVariables.templatesList[index].reference.id}.csv';

    // Write the CSV string to the file
    File file = File(filePath);
    await file.writeAsString(csvString);
  } else {
    directory = await getApplicationDocumentsDirectory();
  }

  print('CSV file saved to: $filePath');
}
