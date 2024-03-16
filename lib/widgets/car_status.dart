import 'package:cars/res/styles.dart';
import 'package:flutter/material.dart';

class CarStatus extends StatelessWidget {
  const CarStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Машина свободна',
          style: h17w500Black.copyWith(
              color: const Color.fromARGB(255, 25, 157, 30)),
        ),
        Text(
          // 'Предварительно до 18:00 (Марина Тимошенко)',
          '',
          style: h12w400Black,
        ),
      ],
    );
  }
}
