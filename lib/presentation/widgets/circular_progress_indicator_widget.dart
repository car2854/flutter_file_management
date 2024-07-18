import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  const CircularProgressIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
      return const Center(child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator()
      )
    );
  }
}