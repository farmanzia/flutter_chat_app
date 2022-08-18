import 'dart:developer';

import 'package:chatapp_firebase/models/chatRoomModel.dart';
import 'package:chatapp_firebase/models/firbaseHelper.dart';
import 'package:chatapp_firebase/screen/chatScreen.dart';
import 'package:chatapp_firebase/screen/completeProfile.dart';
import 'package:chatapp_firebase/screen/login.dart';
import 'package:chatapp_firebase/screen/searchScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/userModel.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  final UserModel userModel;

  HomeScreen({required this.user, required this.userModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String? imgUrl;
  getCurrentUserImg() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatAppUsers")
        .doc(user!.uid)
        .get();
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    setState(() {
      imgUrl = map['profilepic'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserImg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.teal),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 38,
                        child: CircleAvatar(
                          radius: 34,
                          backgroundImage: NetworkImage(imgUrl.toString()),
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.userModel.fullname.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(widget.userModel.email.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          leading: Icon(Icons.home),
                          title: Text("Home"),
                        ),
                        const Divider(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen(
                                        user: widget.user,
                                        userModel: widget.userModel)));
                          },
                          leading: Icon(Icons.search),
                          title: Text("Search Friends"),
                        ),
                        const Divider(),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CompleteProfile(
                                        userModel: widget.userModel,
                                        user: widget.user)));
                          },
                          leading: Icon(Icons.edit),
                          title: Text("Profile Edit"),
                        ),
                        const Divider(),
                        const Spacer(),
                        ListTile(
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LogInScreen()),
                                (route) => false);
                          },
                          leading: Icon(Icons.logout),
                          title: Text("LogOut"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
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
          onPressed: () async {
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
                                                        targetuser: targetUser,
                                                        chatRoomModel:
                                                            chatRoomModel,
                                                        user: widget.user,
                                                        userModel:
                                                            widget.userModel)));
                                      },
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Chat With ${targetUser.fullname.toString()}"),
                                                content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "cancel")),
                                                      InkWell(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "chatrooms")
                                                                .doc(
                                                                    chatRoomModel
                                                                        .chatid)
                                                                .delete();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "delete",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ))
                                                    ]),
                                              );
                                            });
                                      },
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              targetUser.profilepic
                                                  .toString())),
                                      title:
                                          Text(targetUser.fullname.toString()),
                                      subtitle: chatRoomModel.lastMessage != ""
                                          ? Text(
                                              chatRoomModel.lastMessage
                                                  .toString(),
                                            )
                                          : const Text(
                                              "Say hi",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                    );
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
