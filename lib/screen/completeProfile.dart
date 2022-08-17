import 'dart:io';

import 'package:chatapp_firebase/models/userModel.dart';
import 'package:chatapp_firebase/screen/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const CompleteProfile(
      {super.key, required this.userModel, required this.user});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  PickedFile? imageFile;
  String? imgUrl;
  final imagePicker = ImagePicker();
  TextEditingController firstcontroller = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  checkValues() {
    if (firstcontroller.text.trim() == "" || lastController.text.trim() == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("first & last name mendatory")));
    } else {
      uploadData();
    }
  }

  uploadData() async {
    var file = File(imageFile!.path);
    UploadTask uploadTask = FirebaseStorage.instance
        .ref(widget.userModel.email.toString())
        .putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String imgUrl = await snapshot.ref.getDownloadURL();
    UserModel userModel = UserModel(
        uid: widget.userModel.uid,
        fullname: widget.userModel.fullname,
        firstname: firstcontroller.text.trim(),
        lastname: lastController.text.trim(),
        address: addressController.text,
        phone: phoneController.text,
        email: widget.userModel.email,
        profilepic: imgUrl);
    await FirebaseFirestore.instance
        .collection("chatAppUsers")
        .doc(widget.userModel.uid)
        .update(userModel.toMap())
        .then((value) => {
              print("dataUpload"),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                          user: widget.user, userModel: widget.userModel)))
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.teal,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Chat App",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.teal,
                    )),
                const Text(
                  "Complete Profile",
                  style: TextStyle(fontSize: 16),
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
                  controller: firstcontroller,
                  decoration: const InputDecoration(hintText: "First Name"),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: lastController,
                  decoration: const InputDecoration(hintText: "Last Name"),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(hintText: "Phone"),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(hintText: "address"),
                ),
                const SizedBox(
                  height: 12,
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
                        child: const Text("Final Close"))),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickedImage(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: source);

    setState(() {
      imageFile = pickedFile;
    });
  }

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



  // croppedfile(PickedFile file) async {
  //   CroppedFile? croppedImage = await ImageCropper.platform
  //       .cropImage(sourcePath: file.path, compressQuality: 20);
  //   if (croppedImage != null) {
  //     setState(() {
  //       imageFile = croppedImage;
  //     });
  //   }
  // }