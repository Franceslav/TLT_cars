import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../res/styles.dart';

class Button2 extends StatelessWidget {
  Button2({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        title,
        style: h14w500Black.copyWith(color: Colors.white),
      ),
    );
  }
}
