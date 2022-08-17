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
  runApp(MyApp());
  // var cUser = FirebaseAuth.instance.currentUser;
  // User? ccUser;

  // // User cser = FirebaseAuth.instance.currentUser!;

  // UserModel nuserModel =
  //     UserModel(uid: "", fullname: "", email: "", profilepic: "");

  // if (cUser != null) {
  //   UserModel? thisUserModel = await FirebaseHElper.getUserModelById(cUser.uid);
  //   if (thisUserModel != null) {
  //     runApp(LoggedIn(thisUserModel, cUser
  //         // user: cUser,
  //         // userModel: thisUserModel,
  //         ));
  //   } else {
  //     runApp(MyApp(cUser, thisUserModel!));
  //   }
  // } else {
  //   UserModel userModel = nuserModel;

  //   var user = FirebaseAuth.instance.toString();
  //   print("user NOt Found");

  //   runApp(MyApp(FirebaseAuth.instance.currentUser as User, userModel));
  // }
}

class MyApp extends StatelessWidget {
  // User user = FirebaseAuth.instance.currentUser!;
  // final UserModel userModel;

  // MyApp(this.user, this.userModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: LogInScreen()
        //  LogInScreen(user, userModel),
        );
  }
}

class LoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User user;

  LoggedIn(this.userModel, this.user);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(user: user, userModel: userModel),
    );
  }
}
