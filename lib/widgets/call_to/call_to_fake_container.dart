import 'package:flutter/material.dart';

class CallToFakeContainer extends StatelessWidget {
  const CallToFakeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      margin: EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 209, 209, 209).withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: Color(0x19333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'С',
                        style: TextStyle(
                          color: Color(0xFF004B94),
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Сергей Пахневич',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
