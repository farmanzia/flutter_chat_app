class ChatRoomModel {
  String? chatid;
  List<String>? participent;
  ChatRoomModel({this.chatid, this.participent});
  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatid = map["chatid"];
    participent = map["participent"];
  }
  Map<String, dynamic> toMap() {
    return {"chatid": chatid, "participent": participent};
  }
}
