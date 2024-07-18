
import 'package:flutter/material.dart';

Future<bool?> deleteDialog({required String message, required BuildContext context, required void Function() onPressedAccept}) {

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: BorderSide.none,
            ),
          )
        ),
        child: AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            height: 60,
            color: Colors.black,
            child: const Center(child: Text('Confirmacion', style: TextStyle(color: Colors.white),))
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          content: Text(message),
          actionsPadding: const EdgeInsets.only(bottom: 12),
          actions:[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancela la eliminación
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: onPressedAccept,
                  child: const Text("Eliminar"),
                ),
              ],
            ),

          ],
        ),
      );
    },
  );
}