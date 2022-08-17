import 'package:chatapp_firebase/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHElper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("chatapp_user")
        .doc(uid)
        .get();
    if (docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
