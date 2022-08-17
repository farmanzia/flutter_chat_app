import 'dart:developer';

import 'package:chatapp_firebase/models/userModel.dart';
import 'package:chatapp_firebase/screen/homeScreen.dart';
import 'package:chatapp_firebase/screen/searchScreen.dart';
import 'package:chatapp_firebase/screen/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatScreen.dart';
import 'resetScreen.dart';

class LogInScreen extends StatefulWidget {
  // final User user;
  // final UserModel userModel;

  // const LogInScreen({super.key, required this.user, required this.userModel});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _checkedValue = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  checkValues() async {
    if (emailController.text.trim() == "" || passwordController.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("all field mendatory")));
    } else {
      logIn(emailController.text.trim(), passwordController.text);
    }
  }

  logIn(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => HomeScreen(
      //               user: widget.user,
      //               userModel: widget.userModel,
      //             )));
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("chatAppUsers")
          .doc(uid)
          .get();
      UserModel userModel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      log("successfully");
      print("done");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(user: credential!.user!, userModel: userModel)),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User Doesn't Exist")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Chat App",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.teal,
                  )),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _checkedValue,
                decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _checkedValue = !_checkedValue;
                          });
                        },
                        child: _checkedValue != false
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility))),
              ),
              const SizedBox(
                height: 24,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ResetScreen()));
                    },
                    child: const Text(
                      "forgot password ?",
                      style: TextStyle(color: Colors.teal),
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        checkValues();
                      },
                      child: const Text("LOGIN"))),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "don't have account",
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignUp()));
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(color: Colors.teal),
                      )),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
