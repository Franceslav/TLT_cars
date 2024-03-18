import 'dart:convert';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/pages/one_chat_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/chat/chat_select_fake.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  var comment = TextEditingController();

  @override
  void initState() {
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');
    super.initState();
  }

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  Future<String> getUserRole() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(phoneNumber).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      print('User role from Firestore: ${userData['role']}');
      print('User data from Firestore: $userData');
      return userData['role'] ?? '';
    } else {
      print('User document does not exist');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
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
                      'Чаты с пассажирами',
                      style: h17w500Black,
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
              SizedBox(height: 15),
              MyDivider(),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<String>(
                  future: getUserRole(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      String? userRole = snapshot.data;

                      if (userRole == 'Role.driver') {
                        return _buildChatList(fetchPassUsers);
                      } else if (userRole == 'Role.pass') {
                        return _buildChatList(fetchDriverUsers);
                      } else {
                        print('Unknown user role: $userRole');
                        return Text('Unknown user role');
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList(
      Future<List<Map<String, dynamic>>> Function() fetchFunction) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No users available.');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> userData = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  onTap: () async {
                    String chatId = await createChat(userData['phone']);
                    Get.to(OneChatPage(chatId: chatId));
                  },
                  child: ChatSelectFake(
                    userName: userData['firstName'] ?? '',
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchDriverUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Role.driver')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchPassUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Role.pass')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<String> createChat(String phoneNumber) async {
    String userId = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
    String? otherUserPhoneNumber = phoneNumber;

    if (otherUserPhoneNumber == null) {
      return '';
    }

    QuerySnapshot<Map<String, dynamic>> existingChatsSnapshot =
        await FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: otherUserPhoneNumber)
            .get();

    if (existingChatsSnapshot.docs.isNotEmpty) {
      return existingChatsSnapshot.docs.first.id;
    }

    DocumentReference chatRef =
        await FirebaseFirestore.instance.collection('chats').add({
      'participants': [userId, otherUserPhoneNumber],
      'user1': userId,
      'user2': otherUserPhoneNumber,
    });

    await chatRef.collection('participants').doc(userId).set({
      'phone': userId,
    });

    await chatRef.collection('participants').doc(otherUserPhoneNumber).set({
      'phone': otherUserPhoneNumber,
    });

    return chatRef.id;
  }

  Future<String> getOtherUserId(String phoneNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await firestore.collection('users').doc(phoneNumber).get();

    if (userSnapshot.exists) {
      return userSnapshot.id;
    } else {
      throw Exception('User document not found for phone number: $phoneNumber');
    }
  }
}
