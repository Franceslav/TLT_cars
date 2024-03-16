import 'package:flutter/material.dart';

import '../../res/styles.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Positioned(
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: black,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            height: 15,
          ),
        ],
      ),
    );
  }
}
