import 'package:cars/res/styles.dart';
import 'package:flutter/material.dart';

class MapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 480,
          right: 0,
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 50,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.map,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
