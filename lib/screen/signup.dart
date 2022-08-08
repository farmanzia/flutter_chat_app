import 'package:chatapp_firebase/models/userModel.dart';
import 'package:chatapp_firebase/screen/home.dart';
import 'package:chatapp_firebase/screen/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fullNamecontroller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rpasswordController = TextEditingController();
  checkValues() {
    if (fullNamecontroller.text.trim() == "" ||
        emailController.text.trim() == "" ||
        passwordController.text == "" ||
        rpasswordController.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("all field mendatory")));
    } else if (passwordController.text != rpasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("password miss match")));
    } else {
      signUp(emailController.text.trim(), passwordController.text);
    }
  }

  signUp(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("ok");
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
    if (userCredential != null) {
      UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          fullname: fullNamecontroller.text,
          email: emailController.text.trim(),
          profilepic: "");
      await FirebaseFirestore.instance
          .collection("user")
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
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
                    color: Colors.purple,
                  )),
              const Text(
                "now come to close",
                style: TextStyle(fontSize: 10),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                child: CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: fullNamecontroller,
                decoration: InputDecoration(hintText: "Full Name"),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email"),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Password"),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: rpasswordController,
                decoration: InputDecoration(hintText: "Repeat Password"),
              ),
              const SizedBox(
                height: 24,
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
                      child: const Text("SIGNUP"))),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "already have account",
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "LogIn",
                        style: TextStyle(color: Colors.purple),
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
