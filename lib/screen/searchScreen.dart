import 'dart:developer';

import 'package:chatapp_firebase/main.dart';
import 'package:chatapp_firebase/models/chatRoomModel.dart';
import 'package:chatapp_firebase/models/messageModel.dart';
import 'package:chatapp_firebase/models/userModel.dart';
import 'package:chatapp_firebase/screen/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final User user;

  final UserModel userModel;

  const SearchScreen({required this.user, required this.userModel});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  Future<ChatRoomModel?> getchatroom(UserModel targetUser) async {
    ChatRoomModel chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participent.${widget.userModel.uid}", isEqualTo: true)
        .where("participent.${targetUser.uid}", isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      var dataDocs = snapshot.docs[0].data();
      ChatRoomModel existingchatroom =
          ChatRoomModel.fromMap(dataDocs as Map<String, dynamic>);
      chatRoom = existingchatroom;
    } else {
      // log("no created yet");
      //create new one chatroom
      ChatRoomModel newChatRoom = ChatRoomModel(
          chatid: uuid.v1(),
          lastMessage: "",
          participent: {
            widget.userModel.uid.toString(): true,
            targetUser.uid.toString(): true
          });
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chatid)
          .set(newChatRoom.toMap());
      chatRoom = newChatRoom;
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: const Text("Search"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    // contentPadding: EdgeInsets.only(left: 6, bottom: 0),
                    hintText: "Search Friends",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.search),
                    )),
              ),
              const SizedBox(
                height: 4,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatAppUsers")
                      .where("fullname", isEqualTo: controller.text.trim())
                      .where("fullname", isNotEqualTo: widget.userModel.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot querySnapshot =
                            snapshot.data as QuerySnapshot;
                        if (querySnapshot.docs.length > 0) {
                          Map<String, dynamic> map = querySnapshot.docs[0]
                              .data() as Map<String, dynamic>;
                          UserModel searchedUder = UserModel.fromMap(map);
                          return ListTile(
                              onTap: () async {
                                ChatRoomModel? chatRoomModel =
                                    await getchatroom(searchedUder);
                                if (chatRoomModel != null) {
                                  Navigator.pop(context);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatScreen(
                                      targetuser: searchedUder,
                                      chatRoomModel: chatRoomModel,
                                      user: widget.user,
                                      userModel: widget.userModel,
                                    );
                                  }));
                                }
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    searchedUder.profilepic.toString()),
                              ),
                              title: Text(searchedUder.fullname.toString()),
                              subtitle: Text(searchedUder.email.toString()),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ));
                        } else {
                          return const Text("no result found");
                        }
                      } else if (snapshot.hasError) {
                        return const Text("some error occured");
                      } else {
                        return const Text("no result found");
                      }
                    } else {
                      return const SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
