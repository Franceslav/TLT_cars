import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/pages/one_chat_page.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/chat/chat_select_fake.dart';
import 'package:cars/widgets/chat/one_chat_fake.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../res/styles.dart';

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
    // Assuming you are using Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ??
        ''; // Returns user ID if available, otherwise an empty string
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
      return userData['role'] ?? ''; // Return user role if available
    } else {
      print('User document does not exist');
      return ''; // Return empty string if user document doesn't exist
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
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    String? otherUserId = await getOtherUserId(phoneNumber);

    if (otherUserId == null) {
      // Обработка ситуации, когда другой пользователь не найден
      return '';
    }

    QuerySnapshot<Map<String, dynamic>>? existingChatsSnapshot =
        await FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: userId)
            .get();

    if (existingChatsSnapshot == null) {
      // Обработка ситуации, когда снимок не получен
      return '';
    }

    List<QueryDocumentSnapshot<Map<String, dynamic>>> existingChats =
        existingChatsSnapshot.docs;

    // Найдем чат, в котором участвует текущий пользователь и другой пользователь
    QueryDocumentSnapshot<Map<String, dynamic>>? chatDoc;

    try {
      chatDoc = existingChats.firstWhere(
        (doc) {
          final data = doc.data();
          final participants = data['participants'] as List<dynamic>?;

          return participants?.contains(otherUserId) ?? false;
        },
      );
    } catch (e) {
      print('Error finding chat: $e');
    }

    if (chatDoc != null) {
      return chatDoc.id;
    }

    // Если чат не найден, создадим новый
    DocumentReference chatRef =
        await FirebaseFirestore.instance.collection('chats').add({
      'participants': [userId, otherUserId],
    });

    await chatRef.collection('participants').doc(userId).set({
      'name': userId,
    });

    await chatRef.collection('participants').doc(otherUserId).set({
      'name': otherUserId,
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
