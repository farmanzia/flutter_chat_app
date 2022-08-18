import 'dart:developer';

import 'package:chatapp_firebase/models/firbaseHelper.dart';
import 'package:chatapp_firebase/screen/homeScreen.dart';
import 'package:chatapp_firebase/screen/searchScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'models/userModel.dart';
import 'screen/chatScreen.dart';
import 'screen/completeProfile.dart';
import 'screen/login.dart';
import 'screen/signup.dart';

var uuid = Uuid();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? cUser = FirebaseAuth.instance.currentUser;

  if (cUser != null) {
    UserModel? thisUserModel = await FirebaseHElper.getUserModelById(cUser.uid);
    if (thisUserModel != null) {
      runApp(LoggedIn(userModel: thisUserModel, user: cUser));
    } else {
      runApp(MyApp());
    }
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: LogInScreen());
  }
}

class LoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User user;

  const LoggedIn({super.key, required this.userModel, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(user: user, userModel: userModel),
    );
  }
}
