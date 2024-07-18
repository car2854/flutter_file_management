import 'package:file_management/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';

class NewFolderDialogWidget extends StatelessWidget {
  const NewFolderDialogWidget({
    super.key,
    required this.tecFolderName,
    required this.formKey,
    required this.validator,
    required this.onPressedAccept
  });

  final TextEditingController tecFolderName;
  final GlobalKey<FormState> formKey;
  final String? Function(String?)? validator;
  final void Function() onPressedAccept;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // opcional, si deseas bordes redondeados
        side: BorderSide.none, // quita el borde lateral
      ),
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        height: 60,
        color: Colors.black,
        child: const Center(child: Text('Nueva carpeta', style: TextStyle(color: Colors.white),))
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      content: TextFormFieldWidget(
        tecFolderName: tecFolderName,
        validator: validator,
      ),
      actionsPadding: const EdgeInsets.only(bottom: 12),
      actions:[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButtonWidget(
              onPressed: () {
                Navigator.of(context).pop();
              },
              title: 'Cancelar',
            ),
            TextButtonWidget(
              onPressed: onPressedAccept,
              title: 'Guardar',
            ),
          ],
        )


      ],
    );
  }
}