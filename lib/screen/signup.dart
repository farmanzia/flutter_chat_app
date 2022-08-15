import 'dart:io';

import 'package:chatapp_firebase/models/userModel.dart';
import 'package:chatapp_firebase/screen/chatScreen.dart';
import 'package:chatapp_firebase/screen/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  // SignUp({required this.imageFile,required this.imgUrl})
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  PickedFile? imageFile;
  String? imgUrl;

  final imagePicker = ImagePicker();
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
          .showSnackBar(const SnackBar(content: Text("all field mendatory")));
    } else if (passwordController.text != rpasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("password miss match")));
    } else {
      signUp(emailController.text.trim(), passwordController.text);
    }
  }

  signUp(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.push(context, MaterialPageRoute(builder: (_) => LogInScreen()));
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
    //save data to firestore database
    if (userCredential != null) {
      // UserModel userFullName =
      // UserModel(fullname: fullNamecontroller.text.trim());
      String emailStorage = userCredential.user!.email.toString();
      String uid = userCredential.user!.uid;

      // String imgUrl;
      final firebaseStorage = FirebaseStorage.instance;
      var file = File(imageFile!.path);
      if (imageFile != null) {
        var snapshot = await firebaseStorage
            .ref('profilePictures')
            .child(fullNamecontroller.text)
            .putFile(file);
        TaskSnapshot taskSnapshot = await snapshot;

        String imageUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imgUrl = imageUrl;
        });
      }
      UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          fullname: fullNamecontroller.text,
          email: emailController.text.trim(),
          profilepic: imgUrl);
      await FirebaseFirestore.instance
          .collection("chatapp_user")
          .doc(uid)
          .set(userModel.toMap());
      //       {
      //   "full_name": fullNamecontroller.text,
      //   "email": emailController.text.trim(),
      //   "imgUrl": imgUrl
      // }

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
              GestureDetector(
                onTap: () {
                  dialougeBox();
                },
                child: CircleAvatar(
                  backgroundImage: imageFile != null
                      ? FileImage(File(imageFile!.path))
                      : null,
                  radius: 40,
                  child: Icon(
                    imageFile == null ? Icons.person : null,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: fullNamecontroller,
                decoration: const InputDecoration(hintText: "Full Name"),
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
                height: 12,
              ),
              TextFormField(
                controller: rpasswordController,
                decoration: const InputDecoration(hintText: "Repeat Password"),
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

  pickedImage(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    // await imagePicker.pickImage(source: source, imageQuality: 20);
    // croppedfile(pickedFile);
    setState(() {
      imageFile = pickedFile;
    });
  }

  // croppedfile(PickedFile file) async {
  //   CroppedFile? croppedImage = await ImageCropper.platform
  //       .cropImage(sourcePath: file.path, compressQuality: 20);
  //   if (croppedImage != null) {
  //     setState(() {
  //       imageFile = croppedImage;
  //     });
  //   }
  // }

  dialougeBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Pick Profile Image"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () async {
                  pickedImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.browse_gallery_outlined),
                title: const Text("Gallery"),
              ),
              ListTile(
                onTap: () {
                  pickedImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
              )
            ]),
          );
        });
  }
}
