import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> saveHtmlFile(String htmlContent) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final file = File('$path/identity_verification.html');

  await file.writeAsString(htmlContent);

  return file.path;
}
