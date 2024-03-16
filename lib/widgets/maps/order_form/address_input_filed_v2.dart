import 'package:flutter/material.dart';

import '../../../res/styles.dart';

class AddressInputFieldV2 extends StatelessWidget {
  AddressInputFieldV2({
    super.key,
    required this.hintText,
    required this.icon,
    required this.change,
    required this.isActive,
    this.showFrom = false,
    this.showWhere = false,
    this.focus = null,
  });

  String hintText;
  Widget icon;
  bool isActive;
  Function change;
  bool showWhere;
  bool showFrom;
  FocusNode? focus;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 54,
          color: Colors.white,
        ),
        SizedBox(
          height: 42,
          child: TextFormField(
            focusNode: focus,
            enabled: isActive,
            onChanged: (val) => change(val),
            decoration: InputDecoration(
              fillColor: whiteGrey,
              contentPadding: const EdgeInsets.only(top: 8, bottom: 8),
              prefixIcon: icon,
              hintStyle: !hintText.contains('?')
                  ? h13w400Black.copyWith(fontWeight: FontWeight.w500)
                  : h13w400Black,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
