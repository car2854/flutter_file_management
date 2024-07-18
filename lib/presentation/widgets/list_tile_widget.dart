import 'package:file_management/presentation/helpers/helper.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.leadingFormat,
    required this.leadingPath,
    required this.title,
    required this.onTap,
    this.isLocal = false
  });

  final String leadingFormat;
  final String leadingPath;
  final String title;
  final void Function() onTap;
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: getIcon(
      //   format: leadingFormat,
      //   path: leadingPath,
      //   isLocal: isLocal
      // ),
      leading: (leadingFormat == 'folder' || leadingFormat == 'back') 
        ? getIcon(
          format: leadingFormat,
            path: leadingPath,
          )
        : getImage(path: leadingPath, isLocal: isLocal),
      title: Text(title),
      onTap: onTap,
    );
  }
}