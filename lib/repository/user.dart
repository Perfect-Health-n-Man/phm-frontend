import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:phm_frontend/models/user_model.dart';

final backendUrl = dotenv.get('BACKEND_URL');

Future<User?> getUser(String idToken) async{
  final response = await http.get(
    Uri.parse("$backendUrl/users/info"),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $idToken",
    },
  );

  if(response.statusCode == 401){
    throw Exception("token-expired");
  }

  if(response.statusCode == 404) {
    return null;
  }
  final body = jsonDecode(response.body);
  if(body == null) return null;
  return User.fromJson(body);

}

Future<List<String>> getTasks(String idToken) {
  // #TODO: サーバーからタスクを取得する処理を実装
  return Future.value(["task"]);
}

Future<void> createUser(String idToken, User user) async {
  await http.post(
    Uri.parse("$backendUrl/users/info"),
    headers: {
      'Content-Type': "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $idToken",
    },
    body: jsonEncode(<String, dynamic>{
      'name': user.name,
      'email': user.email,
      'gender': user.gender,
      'birthday': user.birthDay.toIso8601String(),
      'height': user.height.toString(),
      'weight': user.weight.toString(),
      'goals': user.goals,
    })
  );
  return;
}