import 'package:flutter/material.dart';

import '../../../res/styles.dart';

class SavedAddress extends StatelessWidget {
  const SavedAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 42,
        child: TextFormField(
          enabled: false,
          decoration: InputDecoration(
            fillColor: whiteGrey,
            filled: true,
            contentPadding: EdgeInsets.all(4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 13, left: 4),
              child: Text('Дом', style: h13w500Black),
            ),
            hintStyle: h13w400Black,
            hintText: '(Маяковского 73)',
          ),
        ),
      ),
    );
  }
}
