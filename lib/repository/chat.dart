import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:phm_frontend/models/message_model.dart';

final backendChatsUrl = "${dotenv.get('BACKEND_URL')}/chats";

Future<Map<String, dynamic>> postChat(String idToken, String message) async {
  final response = await http.post(
      Uri.parse(backendChatsUrl),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $idToken",
      },
      body: jsonEncode({
        "message": message,
      })
  );
  if(response.statusCode == 401){
    throw Exception("token-expired");
  }
  final body = jsonDecode(response.body);
  final answer = body["answer"];
  final form = body["form"];
  return {"answer": answer, "form": form};
}

Future<List<Chat>?> getChats(String idToken, int page) async {
  final response = await http.get(
      Uri.parse("$backendChatsUrl?pages=$page"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $idToken",
      }
  );
  if(response.statusCode == 401) throw Exception("token-expired");
  final body = jsonDecode(response.body);
  final chats = body["chats"];
  if(chats == null) return null;
  List<Chat> messages = [];
  for (var chat in chats) {
    messages.add(Chat.fromJson(chat));
  }
  return Future.value(messages);
}