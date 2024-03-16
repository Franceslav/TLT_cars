import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../res/styles.dart';

class AddressContainer extends StatelessWidget {
  AddressContainer({
    super.key,
    required this.startAddress,
    required this.endAddress,
    required this.startDate,
    required this.endDate,
    required this.name,
  });
  DateTime startDate;
  DateTime endDate;
  String startAddress;
  String endAddress;
  String name;

  @override
  Widget build(BuildContext context) {
    DateTime checkedTime = startDate;
    DateTime currentTime = DateTime.now();
    String date = '';
    if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month) &&
        (currentTime.day == checkedTime.day)) {
      date = 'Сегодня';
    } else if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month)) {
      if ((currentTime.day - checkedTime.day) == 1) {
      } else if ((currentTime.day - checkedTime.day) == -1) {
        date = 'Завтра';
      } else {}
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 196, 195, 195).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Дом', style: h15w500Black),
                        ),
                        SizedBox(height: 5),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Московская 29 подъезда 4',
                              style: h13w400Black),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              right: 10,
              bottom: 8,
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: black,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.delete,
                    color: black,
                    size: 20,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
