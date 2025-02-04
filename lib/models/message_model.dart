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

class Forms {
  List<String> questions;
  Forms(this.questions);
}

class ChatResponse {
  String answer;
  Forms? forms;
  ChatResponse(this.answer, this.forms);
  static fromJson(Map<String, dynamic> json) {
    final formList = List<String>.from(json["form"] as List);
    return ChatResponse(json["answer"], json["form"] == null ? null : Forms(formList));
  }
}