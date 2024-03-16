import 'package:cars/res/styles.dart';
import 'package:flutter/material.dart';

class DriverCarStatus extends StatelessWidget {
  const DriverCarStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Подтверждение заказа',
          style: h17w500Black.copyWith(color: Color.fromARGB(255, 56, 53, 53)),
        ),
        Text(
          'Время: с 11:00 до 18:00 (Марина Тимошенко)',
          //'',
          style: h14w500Black,
        ),
      ],
    );
  }
}
