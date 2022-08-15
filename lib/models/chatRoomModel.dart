class ChatRoomModel {
  String? chatid;
  Map<String, dynamic>? participent;
  String? lastMessage;
  ChatRoomModel({this.chatid, this.participent, this.lastMessage});
  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatid = map["chatid"];
    participent = map["participent"];
    lastMessage = map["lastMessage"];
  }
  Map<String, dynamic> toMap() {
    return {
      "chatid": chatid,
      "participent": participent,
      "lastMessage": lastMessage
    };
  }
}
