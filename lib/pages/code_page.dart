import 'dart:async';

import 'package:cars/bloc/auth/auth_cubit.dart';
import 'package:cars/models/user.dart';
import 'package:cars/pages/driver_home_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/pages/register_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CodePage extends StatefulWidget {
  const CodePage({Key? key, required this.phone, required this.role})
      : super(key: key);

  final String phone;
  final Role role;
  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  var codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 100),
                SvgPicture.asset(
                  'asstes/logo.svg',
                  width: 100,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                const SizedBox(height: 80),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Введите код', style: h15w500Black),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 44,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: codeController,
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
                      onTap: () async {
                        if (kDebugMode) {
                          print('sms');
                        }
                        FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.verifyPhoneNumber(
                          phoneNumber: widget.phone,
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                            if (kDebugMode) {
                              print('verificationCompleted');
                            }
                            await auth.signInWithCredential(credential);
                            if (kDebugMode) {
                              print('Auth complete');
                            }
                            await checkUserInFirestore(context);
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            print(e);
                          },
                          codeSent:
                              (String verificationId, int? resendToken) async {
                            if (kDebugMode) {
                              print('codeSent');
                            }

                            String smsCode = codeController.text;
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: smsCode);
                            await auth.signInWithCredential(credential);
                            if (kDebugMode) {
                              await checkUserInFirestore(context);
                            }
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                          timeout: const Duration(seconds: 120),
                        );
                      },
                      child: Button1(title: 'Подтвердить код'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkUserInFirestore(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String phoneNumber = widget.phone;
    String usersCollectionPath = 'users'; // Замените на свой путь

    DocumentSnapshot userSnapshot =
        await firestore.collection(usersCollectionPath).doc(phoneNumber).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

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
        print('Поле "role" отсутствует в данных пользователя');
      }
    } else {
      print(
          'Пользователь не найден в Firestore, перенаправляем на регистрацию');
      // ignore: use_build_context_synchronously
      context.read<AuthCubit>().set(true);
      Future.delayed(Duration.zero,
          () => Get.to(RegisterPage(phone: phoneNumber, role: widget.role)));
    }
  }
}
