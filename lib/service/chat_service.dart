import 'package:phm_frontend/repository/chat.dart';

import '../models/message_model.dart';

class ChatService {
  static const getChatHistoryNum = 10;
  int page = 1;
  int nowIndex = 9;

  Future<Chat> sendChat(String idToken,String message) async{
    nowIndex++;
    final res = await postChat(idToken, message);
    final answer = res["answer"];
    if(answer != null) {
      return Chat(answer, "ai", DateTime.now().toString(), nowIndex);
    } else {
      throw Exception("Answer is null.");
    }
  }

  Future<List<Chat>?> getNextHistory(String idToken) async{
    final chats = await getChats(idToken, page);

    if(chats == null) {
      return null;
    }
    page++;
    nowIndex += getChatHistoryNum;
    return chats;
  }
}