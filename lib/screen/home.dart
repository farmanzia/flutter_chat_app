import 'package:chatapp_firebase/screen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, actions: [
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance
                ..signOut().then((value) => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LogInScreen())));
            },
            child: Icon(Icons.logout),
          )
        ]),
        body: Center(
          child: Text("Home "),
        ));
  }
}
