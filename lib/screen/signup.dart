import 'dart:io';

import 'package:chatapp_firebase/models/userModel.dart';
import 'package:chatapp_firebase/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  // SignUp({required this.imageFile,required this.imgUrl})
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  XFile? imageFile;
  String? imgUrl;

  ImagePicker? imagePicker;
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
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
    if (userCredential != null) {
      UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          fullname: fullNamecontroller.text,
          email: emailController.text.trim(),
          profilepic: imageFile.toString());
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
                onTap: () {
                  dialougeBox();
                },
                child: CircleAvatar(
                  backgroundImage: imageFile != null
                      ? FileImage(File(imageFile!.path))
                      : null,
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

  pickedImage(ImageSource source) async {
    final XFile? image =
        await imagePicker!.pickImage(source: ImageSource.gallery);
    // await imagePicker.pickImage(source: source, imageQuality: 20);
    croppedfile(image as PickedFile);
    // setState(() {
    //   imageFile = image;

    //   croppedfile(imageFile as PickedFile);
    // });
  }

  croppedfile(PickedFile file) async {
    CroppedFile? croppedImage = await ImageCropper.platform
        .cropImage(sourcePath: file.path, compressQuality: 20);
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage as XFile?;
      });
    }
  }

  dialougeBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Pick Profile Image"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () async {
                  pickedImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.browse_gallery_outlined),
                title: Text("Gallery"),
              ),
              ListTile(
                onTap: () {
                  pickedImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
              )
            ]),
          );
        });
  }
}
