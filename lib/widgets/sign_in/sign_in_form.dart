import 'package:cars/bloc/auth/auth_cubit.dart';
import 'package:cars/models/user.dart';
import 'package:cars/pages/driver_home_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/pages/register_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cars/pages/code_page.dart';
import '../buttons/button1.dart';

class SignInForm extends StatelessWidget {
  SignInForm({
    Key? key,
    required this.role,
  }) : super(key: key);

  final Role role;

  final TextEditingController phoneController =
      TextEditingController(text: '+7');
  final MaskTextInputFormatter phoneMaskFormatter =
      MaskTextInputFormatter(mask: '+7 (###) ### ## ##');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter your phone number', style: h15w500Black),
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
                  borderSide: BorderSide(color: blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: blue, width: 1.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text('We will send a code to the provided number'),
          const SizedBox(height: 40),
          InkWell(
            onTap: () async {
              try {
                await _sendCode(context);
              } catch (e) {
                print('Error sending code: $e');
              }
            },
            child: Button1(title: 'Resend Code'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendCode(BuildContext context) async {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isNotEmpty) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot permissionSnapshot =
          await firestore.collection('permission').doc(phoneNumber).get();

      if (permissionSnapshot.exists) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            await _checkUserInFirestore(context, phoneNumber);
          },
          verificationFailed: (FirebaseAuthException e) {
            print('Verification failed: ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken) async {
            Get.to(() => CodePage(
                  phone: phoneNumber,
                  verificationId: verificationId,
                  role: role,
                ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('Verification code auto retrieval timeout');
          },
          timeout: Duration(seconds: 120),
        );
      } else {
        // Отобразите диалоговое окно с сообщением о том, что номер телефона отсутствует в базе данных
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Ошибка'),
              content: Text(
                  'Ваш номер телефона отсутствует в базе данных. $phoneNumber'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _checkUserInFirestore(
      BuildContext context, String phoneNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(phoneNumber).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      if (userData.containsKey('role')) {
        String userRole = userData['role'];
        if (userRole == 'Role.pass') {
          print('User with passenger role');
          Get.to(PassHomePage());
        } else {
          print('User with driver role');
          Get.to(DriverHomePage());
        }
      } else {
        print('Field "role" is missing in user data');
      }
    } else {
      print('User not found in Firestore, redirecting to registration');
      context.read<AuthCubit>().set(true);
      Future.delayed(Duration.zero,
          () => Get.to(RegisterPage(phone: phoneNumber, role: role)));
    }
  }
}

class CodePage extends StatefulWidget {
  const CodePage({
    Key? key,
    required this.phone,
    required this.verificationId,
    required this.role,
  }) : super(key: key);

  final String phone;
  final String verificationId;
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
                // Остальной код страницы
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
                            borderSide: BorderSide(color: blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: blue, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text('Мы пришлем код на указанный номер'),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: () async {
                        String smsCode = codeController.text;
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: smsCode,
                        );

                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          checkUserInFirestore(context);
                        } catch (e) {}
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
    String formattedPhoneNumber =
        "+${widget.phone.replaceAll(RegExp(r'[^\d]'), '')}";
    String usersCollectionPath = 'users';

    DocumentSnapshot userSnapshot = await firestore
        .collection(usersCollectionPath)
        .doc(formattedPhoneNumber)
        .get();

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
          'Пользователь не найден в Firestore, перенаправляем на регистрацию $formattedPhoneNumber');
      context.read<AuthCubit>().set(true);
      Future.delayed(
          Duration.zero,
          () => Get.to(
              RegisterPage(phone: formattedPhoneNumber, role: widget.role)));
    }
  }
}
