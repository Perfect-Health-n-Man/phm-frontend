import 'package:phm_frontend/repository/chat.dart';
import 'package:phm_frontend/utils/to_message.dart';

import '../models/message_model.dart';

class ChatService {
  static const getChatHistoryNum = 10;
  int page = 1;
  int nowIndex = 9;

  Future<ChatResponse> sendChat(String idToken,String message) async{
    nowIndex++;
    final res = await postChat(idToken, message);
    if(res["answer"] != null || res["form"] != null) {
      return ChatResponse.fromJson(res);
    }

    throw Exception("invalid response");
  }

  Future<ChatResponse> sendFormAnswer(String idToken, List<String> forms, List<String> answers) async {
    final answerMessage = listToMessage(answers);
    return await sendChat(idToken, answerMessage);
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