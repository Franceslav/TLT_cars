import 'package:cars/bloc/route_from_to/route_from_to.dart';
// Импорт ChatPage
import 'package:cars/widgets/chat/one_chat_fake.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../res/styles.dart';

class OneChatPage extends StatefulWidget {
  final String chatId;

  OneChatPage({
    required this.chatId,
    Key? key, 
  }) : super(key: key);

  @override
  State<OneChatPage> createState() => _OneChatPageState();
}

class _OneChatPageState extends State<OneChatPage> {
  late String userId; 

  @override
  void initState() {
    super.initState();
    userId = getUserId(); 
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
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    'Чат с пассажиром',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            SizedBox(height: 10),
            Expanded(
              child: ChatPage(
                initialChatId: widget.chatId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getUserId() {

    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }
}
