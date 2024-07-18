import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    this.validator,
    required this.tecFolderName,
  });

  final TextEditingController tecFolderName;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: tecFolderName,
      decoration: const InputDecoration(
        labelText: 'Nombre de la carpeta',
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        isDense: true, 
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue, // Color del borde inferior cuando está enfocado
            width: 2.0, // Ancho del borde inferior cuando está enfocado
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // Color del borde inferior
            width: 1.0, // Ancho del borde inferior
          ),
        ),
      ),
      validator: validator
    );
  }
}