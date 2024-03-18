import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart'; 

class ChatPage extends StatefulWidget {
  final String initialChatId;

  const ChatPage({
    required this.initialChatId,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String chatId;
  late String userId;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatId = widget.initialChatId;
    getUserId();
  }

  void getUserId() {
    setState(() {
      userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Нет сообщений'));
          }

          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var messageData = snapshot.data!.docs[index];
              String messageText = messageData['text'];
              String messageSender = messageData['sender'];
              String messageRecipient = messageData['recipient'];
              Timestamp messageTimestamp = messageData['timestamp'];

              String messageTimeString = DateTime.fromMillisecondsSinceEpoch(
                      messageTimestamp.millisecondsSinceEpoch)
                  .toString();

              bool isCurrentUserSender = messageSender == userId;
              bool isIncomingMessage = messageRecipient == userId;

              if (isIncomingMessage && !isCurrentUserSender && index == 0) {
                sendOneSignalNotification(messageText, userId);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: isCurrentUserSender
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isCurrentUserSender
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            messageTimeString,
                            style: TextStyle(
                              color: Color(0x7F333333),
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            messageText,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Введите сообщение',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _sendMessage(_messageController.text.trim());
                  _messageController.clear();
                },
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getOtherUserId(String chatId) async {
    DocumentSnapshot<Map<String, dynamic>> chatSnapshot =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();

    if (chatSnapshot.exists) {
      List<dynamic> participants = chatSnapshot.data()?['participants'] ?? [];
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

      String otherUserId = participants.firstWhere((id) => id != currentUserId,
          orElse: () => '');

      return otherUserId;
    } else {
      throw Exception('Chat not found for chatId: $chatId');
    }
  }

  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      String otherUserId = await getOtherUserId(chatId);
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      DocumentReference chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);

      if (!(await chatRef.get()).exists) {
        String newChatId = await createNewChat(userId, otherUserId);
        setState(() {
          chatId = newChatId;
        });
      }

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': message,
        'sender': userId,
        'recipient': otherUserId,
        'timestamp': Timestamp.now(),
      });

      // Отправляем уведомление после добавления сообщения
      if (userId != otherUserId) {
        sendOneSignalNotification(message, otherUserId);
      }
    }
  }

  Future<String> createNewChat(String userId, String otherUserId) async {
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

  void sendOneSignalNotification(String message, String recipientUserId) async {
    final String oneSignalApiKey =
        'NzU1ZTU4NGMtNDBkZC00ZGE0LWI3MzktZmI3NjIxYTNiNjAz';
    final String oneSignalAppId = 'd63d1533-d464-4176-b5b3-7707c4d83bf8';
    final String notificationTitle = 'Новое сообщение';
    final String notificationContent = 'Получено новое сообщение: $message';

    final String apiUrl = 'https://onesignal.com/api/v1/notifications';
    final Map<String, dynamic> requestBody = {
      'app_id': oneSignalAppId,
      'included_segments': ['All'],
      'headings': {'en': notificationTitle},
      'contents': {'en': notificationContent},
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $oneSignalApiKey',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Уведомление успешно отправлено $message');
    } else {
      print('Ошибка отправки уведомления: ${response.body}');
    }
  }
}
