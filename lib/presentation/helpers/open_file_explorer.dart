  import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// Abrir los archivos del dispositivo
Future<List<File>> openFileExplorer(BuildContext context) async {
  try {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      // Validaciones de archivos
      allowedExtensions: ['git', 'png', 'jpg', 'pdf'],
    );

    if (result != null) {
      List<File> pickedFiles =
          result.paths.map((path) => File(path!)).toList();

      // await loadFolders.moveFilesToAppDirectory(pickedFiles);

      return pickedFiles;

      // setState(() {
      //   _files.addAll(pickedFiles);
      // });
    }
    return [];
  } catch (e) {
    print('Error al seleccionar el archivo: $e');
    return [];
  }
}