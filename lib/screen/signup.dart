import 'package:chatapp_firebase/screen/login.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                decoration: InputDecoration(hintText: "Full Name"),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Email"),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Password"),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
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
                      onPressed: () {}, child: const Text("SIGNUP"))),
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
