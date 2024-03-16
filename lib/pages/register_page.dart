import 'package:cars/models/user.dart';
import 'package:cars/pages/driver_home_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.phone, required this.role})
      : super(key: key);

  final String phone;
  final Role role;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _sName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var validator = (value) =>
      value != null && value.isNotEmpty ? null : 'Поле не должно быть пустым';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text('Регистрация', style: h24w500Black),
                  const SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: validator,
                    controller: _lName,
                    cursorColor: blue,
                    decoration: InputDecoration(
                      label: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Фамилия:'),
                          Text(
                            '*',
                            style: TextStyle(color: blue, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: validator,
                    controller: _fName,
                    decoration: InputDecoration(
                      label: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Имя:'),
                          Text(
                            '*',
                            style: TextStyle(color: blue, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _sName,
                    decoration: const InputDecoration(
                      label: Text('Отчество'),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;

                        // Форматирование номера телефона
                        String formattedPhone =
                            widget.phone.replaceAll(RegExp(r'[^\d]'), '');

                        String documentId =
                            '+$formattedPhone'; // Форматированный номер телефона для использования в качестве идентификатора документа

                        // Создаем данные пользователя
                        Map<String, dynamic> userData = {
                          'lastName': _lName.text,
                          'firstName': _fName.text,
                          'secondName': _sName.text,
                          'phone': documentId,
                          'role': widget.role.toString()
                        };

                        // Добавляем данные в коллекцию "users"
                        try {
                          await firestore
                              .collection('users')
                              .doc(documentId)
                              .set(userData);
                          print('Данные успешно добавлены в Firestore');
                        } catch (e) {
                          print('Ошибка при добавлении данных в Firestore: $e');
                        }

                        //save to base and go to next Form
                        print('ok');

                        if (userData.containsKey('role')) {
                          String userRole = userData['role'];
                          if (userRole == 'Role.pass') {
                            print('Пользователь с ролью пассажира');
                            Get.to(PassHomePage());
                          } else {
                            print('Пользователь с ролью водителя');
                            Get.to(DriverHomePage());
                          }
                        } else {
                          print(
                              'Поле "role" отсутствует в данных пользователя');
                        }
                      }
                    },
                    child: Button1(title: 'Зарегестрироваться'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
