import 'package:drivres_app/buisnis_logic/notifications_system/push_notifications_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/message_model/message.dart';
import '../app_manager/color_manager/colormanager.dart';
import '../app_manager/text_manager/textmanager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: MyDefaultTextStyle(
          text: "Chat Room",
          height: 20,
          bold: true,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref()
                  .child('message_room')
                  .child(Provider.of<NotificationsSystem>(context)
                      .roomid
                      .toString())
                  .orderByChild("time")
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                  print(
                      "---------------------------------------------------------");

                  Map<dynamic, dynamic>? messagesData =
                      dataSnapshot.value as Map?;
                  List<Message> messagesList = [];

                  messagesData!.forEach((key, value) {
                    Message message = Message(
                        message: value["message"],
                        isSender: value["sender"],
                        dateTime: value["time"]);
                    messagesList.add(message);
                  });

                  if (messagesData != null) {
                    return ListView.builder(
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        bool isSender =
                            messagesList[index].isSender == 'driver';

                        return Align(
                          alignment: isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: isSender ? maincolor : black,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                              ),
                            ),
                            child: Text(
                              messagesList[index].message,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No messages found');
                  }
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DatabaseReference? newMessage;
  sendMessage(message) {
    newMessage = FirebaseDatabase.instance
        .ref()
        .child("message_room")
        .child(Provider.of<NotificationsSystem>(context, listen: false)
            .roomid
            .toString())
        .push();
    DatabaseReference fireBaseRef = FirebaseDatabase.instance
        .ref()
        .child("message_room")
        .child(Provider.of<NotificationsSystem>(context, listen: false)
            .roomid
            .toString())
        .child(newMessage!.key.toString());

    fireBaseRef.set({
      'message': message,
      'senderID': FirebaseAuth.instance.currentUser!.uid,
      'sender': "driver",
      'time': DateTime.now().toUtc().toIso8601String()
    });
  }
}
