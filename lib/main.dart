import 'dart:developer';

import 'package:chatapp_firebase/screen/searchScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'screen/chatScreen.dart';
import 'screen/login.dart';

var uuid = Uuid();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? cUser = FirebaseAuth.instance.currentUser;
  if (cUser != null) {
    if (cUser.uid != null) {
      print(cUser.uid);
      runApp(const LoggedIn());
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const LogInScreen(),
    );
  }
}

class LoggedIn extends StatelessWidget {
  const LoggedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LogInScreen(),
    );
  }
}
