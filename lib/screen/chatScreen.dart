import 'dart:developer';

import 'package:chatapp_firebase/models/chatRoomModel.dart';
import 'package:chatapp_firebase/models/userModel.dart';
import 'package:chatapp_firebase/screen/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  // String? uid;
  // ChatScreen({required this.uid});
  // const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? _auth = FirebaseAuth.instance.currentUser;

  TextEditingController controller = TextEditingController();
  String? uName;
  // DocumentSnapshot? data;
  getData() async {
    uName = _auth!.displayName.toString();
    setState(() {});
    // CollectionReference users =
    //     FirebaseFirestore.instance.collection('new_user');
    // final snapshot = await users.doc(_auth!.uid).get();
    // final data = snapshot.data() as Map<String, dynamic>;

    // return data['full_name'];

    // print(_auth!.uid);
    // setState(() {
    //   uName = data['full_name'];
    // });

    // await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
    //   setState(() {
    //     uName = snapshot.data;
    //   });
    // });
  }

  List<dynamic> msg = [];
  var userName;

  @override
  void initState() {
    // getUserData();
    // TODO: implement initState
    super.initState();
    getData();
    // getUserData();
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
                const SizedBox(width: 4),
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
        body: Center(
          child: Column(children: [
            Text(uName!),
            Expanded(
                child: ListView.builder(
                    itemCount: msg.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.teal,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(msg[index])
                          ],
                        ),
                      );
                    })),
            Spacer(),
            messageBox(context)
          ]),
        ));
  }

  Widget messageBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        // to show add button, textformfield for input,send at bottom
        height: MediaQuery.of(context).size.height * 0.09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // SizedBox(
            //     height: 50,
            //     width: 50,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           _toggleBtn = !_toggleBtn;
            //         });
            //       },
            //       style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all(
            //               _toggleBtn ? Colors.grey.shade300 : Colors.amber),
            //           shape: MaterialStateProperty.all(RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(30)))),
            //       child: _toggleBtn
            //           ? const Icon(
            //               Icons.add,
            //               size: 20,
            //               color: Colors.amber,
            //             )
            //           : Icon(
            //               Icons.close,
            //               size: 20,
            //               color: Colors.grey.shade300,
            //             ),
            //     )),
            const SizedBox(
              width: 4,
            ),
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
                      // suffixIcon: _toggleBtn
                      //     ? null
                      //     : InkWell(
                      //         onTap: () {},
                      //         child: const Icon(
                      //           Icons.attach_file_outlined,
                      //           color: Colors.teal,
                      //         ),
                      //       ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      hintText: "Type Message")),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            msg.add(controller.text);
                          });
                          controller.clear();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey.shade300),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                        child: const Icon(
                          Icons.send,
                          color: Colors.teal,
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // getUserData() async {
  //   User? cUser = FirebaseAuth.instance.currentUser;
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //   DocumentSnapshot documentSnapshot =
  //       await firebaseFirestore.collection("new_user").doc(cUser!.uid).get();
  //   //     .then<dynamic>((DocumentSnapshot snapshot) {
  //   //   setState(() {
  //   //     userName = snapshot['full_name'];
  //   //   });
  //   // });
  //   setState(() {
  //     uName = documentSnapshot;
  //   });
  //   print("----------------------");
  //   print(uName.data);
  //   // setState(() {
  //   //   userName = documentSnapshot['full_name'];
  //   // });
  //   // if (documentSnapshot.data() != null) {
  //   //   Map<String, dynamic> map =
  //   //       documentSnapshot.data() as Map<String, dynamic>;
  //   //   print(map);
  //   // } else {
  //   //   return "Notihing";
  //   // }
  //   // var userFullName = getimg["full_name"];
  //   // log(userFullName);
  //   // print(userName);

  //   // setState(() {
  //   //   userName = userFullName;
  //   // });
  // }
}
