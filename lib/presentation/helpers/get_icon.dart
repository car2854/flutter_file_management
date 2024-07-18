import 'dart:io';

import 'package:flutter/material.dart';

Widget getIcon({required String format, required String path}){
  if (format == 'folder') return const Icon(Icons.folder); 
  return const Icon(Icons.arrow_back); 
}

Widget getImage({required String path, required bool isLocal}){
  return (isLocal) 
  ? Image(
    image: FileImage(File(path)),
    width: 25,
    height: 25,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null){
        return child;
      } else {
        return const SizedBox(
          width: 20,
          height: 20,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    },
  )
  : Image.network(
    path, 
    width: 25, 
    height: 25, 
    fit: BoxFit.cover, 
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null){
        return child;
      } else {
        return const SizedBox(
          width: 20,
          height: 20,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    },
  ) ; 
}