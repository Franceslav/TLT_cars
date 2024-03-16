import 'dart:convert';

import 'package:cars/pages/address_page.dart';
import 'package:cars/pages/call_to_page.dart';
import 'package:cars/pages/car_settings_page.dart';
import 'package:cars/pages/chats_page.dart';
import 'package:cars/pages/history_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/pages/plan_page.dart';
import 'package:cars/res/config.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../bloc/app_bottom_form/app_bottom_form.dart';

class PassMenu extends StatelessWidget {
  const PassMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width - 50,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios)),
                Text('Меню пассажира', style: h15w500Black),
              ],
            ),
            SizedBox(height: 10),
            MyDivider(),
            SizedBox(height: 20),
            context.read<AppBottomFormCubit>().get() == ShowBottomForm.orderNow
                ? ListTile(
                    onTap: () {
                      context
                          .read<AppBottomFormCubit>()
                          .set(ShowBottomForm.plan);
                      Get.to(PassHomePage());
                      Navigator.of(context).pop();
                    },
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: Text('Запланировать поездку', style: h14w400Black),
                  )
                : ListTile(
                    onTap: () {
                      context
                          .read<AppBottomFormCubit>()
                          .set(ShowBottomForm.orderNow);
                      Get.to(PassHomePage());
                      Navigator.of(context).pop();
                    },
                    leading: const Icon(Icons.online_prediction_rounded),
                    title: Text('Заказать сейчас', style: h14w400Black),
                  ),
            ListTile(
              onTap: () => Get.to(HistoryPage()),
              leading: const Icon(Icons.history),
              title: Text('История поездок', style: h14w400Black),
            ),
            ListTile(
              onTap: () => Get.to(AddressPage()),
              leading: const Icon(Icons.home_outlined),
              title: Text('Мои адреса', style: h14w400Black),
            ),
            ListTile(
              onTap: () => Get.to(PlanPage()),
              leading: const Icon(Icons.calendar_month_rounded),
              title: Text('Запланированные поездки', style: h14w400Black),
            ),
            ListTile(
              onTap: () => Get.to(CarSettingsPage()),
              leading: const Icon(Icons.settings_outlined),
              title: Text('Состояние машины', style: h14w400Black),
            ),
            InkWell(
              onTap: () => Get.to(ChatsPage()),
              child: ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: Text('Чаты с водителем', style: h14w400Black),
              ),
            ),
            ListTile(
              onTap: () => Get.to(CallToPass()),
              leading: const Icon(Icons.call_outlined),
              title: Text('Позвонить водителю', style: h14w400Black),
            ),
            ListTile(
              //onTap: () => Get.to(CallToPass()),
              onTap: () async {
                Map<String, dynamic> notification = {
                  "app_id": oneSignalAppId,
                  "contents": {"en": 'HELLO'},
                  "headings": {"en": 'hello'},
                  "send_after": DateTime.now()
                      .add(Duration(seconds: 10))
                      .toUtc()
                      .toIso8601String(),
                  "included_segments": ["All"]
                };

                final headers = {
                  'Content-Type': 'application/json',
                  'Authorization':
                      'Basic MjM1YWM4YzctMmNjZS00ODdkLTllMTYtNzM0ODY2YmMzYmZk',
                };

                var dio = Dio();
                final response = await dio.post(
                    'https://onesignal.com/api/v1/notifications',
                    options: Options(headers: headers),
                    data: notification);
                print(response);
              },
              leading: const Icon(Icons.call_outlined),
              title: Text('Тест Пуш 10 сек', style: h14w400Black),
            ),
          ],
        ),
      ),
    );
  }
}
