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
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User? user;
  checkValues() async {
    if (emailController.text.trim() == "" || passwordController.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("all field mendatory")));
    } else {
      signUp(emailController.text.trim(), passwordController.text);
    }
  }

  signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("chatapp_user")
          .doc(uid)
          .get();
      UserModel userModel =
          UserModel.fromMap(documentSnapshot as Map<String, dynamic>);
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
                    fontSize: 30,
                    color: Colors.teal,
                  )),
              const Text(
                "now come to close",
                style: TextStyle(fontSize: 10),
              ),
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
                decoration: const InputDecoration(hintText: "Password"),
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
