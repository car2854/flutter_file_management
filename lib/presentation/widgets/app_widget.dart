import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.onPressedNewFolder,
    required this.onPressedUploadFile,
    required this.title,
    this.history = ''
  });

  final void Function()? onPressedNewFolder;
  final void Function()? onPressedUploadFile;
  final String title;
  final String history;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18),)
              ),
              IconButton(
                icon: const Icon(Icons.create_new_folder_rounded, color: Colors.white,),
                onPressed: onPressedNewFolder,
              ),
              IconButton(
                icon: const Icon(Icons.upload, color: Colors.white,),
                onPressed: onPressedUploadFile, 
              ),
            ],
          ),
          // Aqui se muestra el historial
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.only(right: 8),child: Text('Ruta: ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                Text(history.trim().isEmpty ? '/' : history, style: const TextStyle(color: Colors.white),),
              ],
            )
          )
        ],
      ),
    );
  }
}