import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/buttons/button2.dart';
import 'package:cars/widgets/planing/planing_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../res/styles.dart';
import '../widgets/other/my_divider.dart';

class PlanPage extends StatefulWidget {
  PlanPage({
    super.key,
  });

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
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
              //color: Colors.white,

              width: double.infinity,
              padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    'Запланированые поездки',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 5),
            MyDivider(),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlaningContainer(
                        name: 'Иванов Иван',
                        startAddress: 'Миронова 29',
                        endAddress: 'Комсомольская 29',
                        startDate: DateTime.now().add(Duration(hours: 2)),
                        endDate: DateTime.now().add(Duration(hours: 2)),
                      ),
                      PlaningContainer(
                        name: 'Иванов Иван',
                        startAddress: 'Миронова 29',
                        endAddress: 'Комсомольская 29',
                        startDate: DateTime.now().add(Duration(hours: 12)),
                        endDate: DateTime.now().add(Duration(hours: 2)),
                      ),
                      PlaningContainer(
                        name: 'Иванов Иван',
                        startAddress: 'Миронова 29',
                        endAddress: 'Комсомольская 29',
                        startDate: DateTime.now().add(Duration(hours: 42)),
                        endDate: DateTime.now().add(Duration(hours: 2)),
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Button2(title: 'Запланировать поездку'),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
