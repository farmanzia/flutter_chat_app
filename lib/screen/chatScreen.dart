import 'dart:developer';

import 'package:chatapp_firebase/models/chatRoomModel.dart';
import 'package:chatapp_firebase/models/messageModel.dart';
import 'package:chatapp_firebase/models/userModel.dart';
import 'package:chatapp_firebase/screen/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  final UserModel targetuser;
  final ChatRoomModel chatRoomModel;
  final User user;
  final UserModel userModel;

  const ChatScreen(
      {super.key,
      required this.targetuser,
      required this.chatRoomModel,
      required this.user,
      required this.userModel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? _auth = FirebaseAuth.instance.currentUser;

  TextEditingController controller = TextEditingController();
  void sendMessage() async {
    String msg = controller.text.trim();
    if (msg != null) {
      //send messages
      MessageModel newMessage = MessageModel(
          messageId: uuid.v1(),
          sender: widget.userModel.uid,
          createdon: DateTime.now(),
          text: msg,
          seen: false);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatid)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      widget.chatRoomModel.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatid)
          .set(widget.chatRoomModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    var uid;
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            automaticallyImplyLeading: true,
            title: Row(
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(
                  widget.targetuser.profilepic.toString(),
                )),
                const SizedBox(width: 8),
                Text(widget.targetuser.fullname.toString())
              ],
            ),
            centerTitle: true,
            actions: [
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance
                    ..signOut().then((value) => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => LogInScreen())));
                },
                child: const Icon(Icons.logout),
              ),
              const SizedBox(
                width: 8,
              )
            ]),
        body: SafeArea(
          child: Container(
            child: Column(children: [
              Expanded(
                  child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatRoomModel.chatid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.active) {
                      if (snapshots.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshots.data as QuerySnapshot;

                        return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);
                              return Row(
                                mainAxisAlignment: (currentMessage.sender ==
                                        widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                            ? Colors.grey
                                            : Colors.teal,
                                      ),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )),
                                ],
                              );
                            });
                      } else if (snapshots.hasError) {
                        return const Center(child: Text("Some Error Occured"));
                      } else {
                        return const Center(
                          child: Text("Say Hi"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                          controller: controller,
                          minLines: 1,
                          maxLines: 5,
                          // maxLength: 500,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade300,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              hintText: "Type Message")),
                    ),
                    Container(
                        height: 50,
                        width: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            sendMessage();
                            setState(() {});
                            controller.clear();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.grey.shade300),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                          child: const Icon(
                            Icons.send,
                            color: Colors.teal,
                          ),
                        ))
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
