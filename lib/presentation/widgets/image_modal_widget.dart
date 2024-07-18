import 'dart:io';

import 'package:flutter/material.dart';

class ImageModal extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;

  const ImageModal(
    {super.key, this.imageUrl, this.imagePath}
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            (imageUrl != null) ? 
            Image.network(
              imageUrl!,
              height: 300.0, 
              width: double.infinity,
              fit: BoxFit.contain,
            ) : 
            Image.file(
              File(imagePath!),
              height: 300, 
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 38,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  iconSize: 48,
                  onPressed: (){
                    Navigator.of(context).pop(); // Cierra el modal al presionar el botón
                  },
                  icon: const Icon(Icons.close, color: Colors.black, size: 30,)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}