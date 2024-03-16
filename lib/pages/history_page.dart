import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../res/styles.dart';
import '../widgets/planing/planing_container.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({
    super.key,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var comment = TextEditingController();

  @override
  void initState() {
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              width: double.infinity,
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios, color: black),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    'История поездок',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlaningContainer(
                  name: 'Иванов Иван',
                  startAddress: 'Миронова 29',
                  endAddress: 'Комсомольская 29',
                  startDate: DateTime.now().add(Duration(days: 4)),
                  endDate: DateTime.now().add(Duration(days: 3)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
