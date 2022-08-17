import 'package:chatapp_firebase/screen/login.dart';
import 'package:chatapp_firebase/screen/searchScreen.dart';
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
        automaticallyImplyLeading: false,
        title: const Text("Chat App"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance
                ..signOut().then((value) => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LogInScreen())));
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
      body: Center(child: Text("home")),
    );
  }
}
