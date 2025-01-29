class Chat {
  String message;
  String type;
  String dateTime;
  int index;
    Chat(this.message, this.type, this.dateTime, this.index);

  static Chat fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    final type = json['type'];
    final datetime = json["datetime"];
    final index = json["message_id"];
    return Chat(message, type, datetime, index);
  }
}