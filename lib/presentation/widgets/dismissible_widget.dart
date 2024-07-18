import 'package:flutter/material.dart';

class DismissibleWidget extends StatelessWidget {
  const DismissibleWidget({
    super.key,
    // required this.dimissibleKey,
    required this.confirmDismiss,
    required this.widget
  });

  // final String dimissibleKey;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      confirmDismiss: confirmDismiss,
      child: widget,
    );
  }
}