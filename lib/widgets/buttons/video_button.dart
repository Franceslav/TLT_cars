import 'package:cars/res/styles.dart';
import 'package:flutter/material.dart';

class VideoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const VideoButton({Key? key, required this.onPressed}) : super(key: key);

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
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'asstes/cam.png',
                    color: blue,
                    scale: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
