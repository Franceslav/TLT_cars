import 'dart:async';

import 'package:cars/bloc/auth/auth_cubit.dart';
import 'package:cars/models/user.dart';
import 'package:cars/pages/register_page.dart';
import 'package:cars/res/styles.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cars/pages/code_page.dart';

import '../buttons/button1.dart';

class SignInForm extends StatelessWidget {
  SignInForm({
    super.key,
    required this.role,
  });
  Role role;

  var phoneController = TextEditingController(text: '+7');
  final phoneMaskFormatter = MaskTextInputFormatter(mask: '+7 (###) ### ## ##');
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blueGrey,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Введите свой номер телефона', style: h15w500Black),
          const SizedBox(height: 15),
          SizedBox(
            height: 44,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneController,
              inputFormatters: [phoneMaskFormatter],
              cursorColor: blue,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: blue,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(' Мы пришлем код на указанный номер'),
          const SizedBox(height: 40),
          InkWell(
            onTap: () {
              Get.to(() => CodePage(
                    phone: phoneController.text,
                    role: role,
                  ));
            },
            child: Button1(title: 'Отправить код повторно'),
          ),
        ],
      ),
    );
  }
}
