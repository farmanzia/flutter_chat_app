class UserModel {
  String? uid;
  String? fullname;
  String? firstname;
  String? lastname;
  String? address;
  String? phone;
  String? email;
  String? profilepic;
  UserModel(
      {this.uid,
      this.fullname,
      this.firstname,
      this.lastname,
      this.address,
      this.phone,
      this.email,
      this.profilepic});
  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    fullname = map['fullname'];
    firstname = map['firstname'];
    lastname = map['lastname'];
    address = map['address'];
    phone = map['phone'];
    email = map['email'];
    profilepic = map['profilepic'];
  }
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "firstname": firstname,
      "lastname": lastname,
      "address": address,
      "phone": phone,
      "email": email,
      "profilepic": profilepic
    };
  }
}
