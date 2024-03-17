import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  final String chatId;

  const ChatPage({required this.chatId, Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чат'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
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
              String text = messageData['text'];
              String sender = messageData['sender'];
              Timestamp timestamp = messageData['timestamp'];
              String timeString =
                  "${timestamp.toDate().hour}:${timestamp.toDate().minute}";

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: sender == 'Вы'
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: sender == 'Вы'
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
                            timeString,
                            style: TextStyle(
                              color: Color(0x7F333333),
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            text,
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
                  _messageController
                      .clear(); // Clear the text field after sending
                },
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': message,
        'sender': 'Вы',
        'timestamp': Timestamp.now(),
      });

      sendOneSignalNotification(
          message); // Вызываем функцию отправки уведомления
    }
  }

  void sendOneSignalNotification(String message) async {
    final String oneSignalApiKey = 'YOUR_ONE_SIGNAL_API_KEY';
    final String oneSignalAppId = 'YOUR_ONE_SIGNAL_APP_ID';
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
      print('Уведомление успешно отправлено');
    } else {
      print('Ошибка отправки уведомления: ${response.body}');
    }
  }
}
