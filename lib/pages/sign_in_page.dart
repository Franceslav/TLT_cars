import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/user.dart';
import '../widgets/sign_in/pass_driver_tab.dart';
import '../widgets/sign_in/sign_in_form.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Role role = Role.pass;

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
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                SvgPicture.asset(
                  'asstes/logo.svg',
                  width: 100,
                ),
                const SizedBox(height: 20),
                PassDriverTab(
                  role: role,
                  change: (value) => setState(() => role = value),
                ),
                const SizedBox(height: 20),
                SignInForm(role: role),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
