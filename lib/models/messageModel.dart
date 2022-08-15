class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;
  MessageModel(
      {this.messageId, this.sender, this.text, this.seen, this.createdon});
  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = ["messageId"] as String;
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"];
  }
  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon
    };
  }
}
