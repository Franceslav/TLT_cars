import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/widgets/address/address_container.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../res/styles.dart';
import '../widgets/buttons/button2.dart';
import '../widgets/planing/planing_container.dart';

class AddressAddPage extends StatefulWidget {
  AddressAddPage({
    super.key,
  });

  @override
  State<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
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
                    'Новый адрес',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Название',
                        labelStyle: TextStyle(color: black)),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Адрес',
                        labelStyle: TextStyle(color: black)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Button2(title: 'Сохранить'),
            ),
            //SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
