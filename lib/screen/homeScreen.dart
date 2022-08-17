import 'package:chatapp_firebase/models/chatRoomModel.dart';
import 'package:chatapp_firebase/models/firbaseHelper.dart';
import 'package:chatapp_firebase/screen/chatScreen.dart';
import 'package:chatapp_firebase/screen/login.dart';
import 'package:chatapp_firebase/screen/searchScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/userModel.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  //  = FirebaseAuth.instance.currentUser as User;

  final UserModel userModel;

  HomeScreen({required this.user, required this.userModel});
  //  = UserModel();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text("Chat App"),
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchScreen(
                        user: widget.user, userModel: widget.userModel)));
          },
          child: Icon(Icons.search),
        ),
        body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("participent.${widget.userModel.uid}", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.active) {
                  if (snapshots.hasData) {
                    QuerySnapshot querySnapshot =
                        snapshots.data as QuerySnapshot;
                    return ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                              querySnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          Map<String, dynamic> participants =
                              chatRoomModel.participent!;
                          List<String> participantKeys =
                              participants.keys.toList();
                          participantKeys.remove(widget.userModel.uid);
                          return FutureBuilder(
                              future: FirebaseHElper.getUserModelById(
                                  participantKeys[0]),
                              builder: (context, userData) {
                                if (userData.connectionState ==
                                    ConnectionState.done) {
                                  if (userData.data != null) {
                                    UserModel targetUser =
                                        userData.data as UserModel;
                                    return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                          targetuser:
                                                              targetUser,
                                                          chatRoomModel:
                                                              chatRoomModel,
                                                          user: widget.user,
                                                          userModel: widget
                                                              .userModel)));
                                        },
                                        leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                targetUser.profilepic
                                                    .toString())),
                                        title: Text(
                                            targetUser.fullname.toString()),
                                        subtitle:
                                            chatRoomModel.lastMessage != ""
                                                ? Text(
                                                    chatRoomModel.lastMessage
                                                        .toString(),
                                                  )
                                                : Text(
                                                    "Say hi",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ));
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              });
                        });
                  } else if (snapshots.hasError) {
                    return Center(
                      child: Text(snapshots.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text("no chat here"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }
}
