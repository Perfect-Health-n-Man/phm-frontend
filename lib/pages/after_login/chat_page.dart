import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:phm_frontend/main.dart';
import 'package:phm_frontend/models/message_model.dart' as types;

import '../../service/chat_service.dart';
import '../before_login/login_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

final userMe = types.User(
  id: 'me',
  firstName: "あなた",
);

final userAI = types.User(
  id: 'ai',
  firstName: "AI",
);

class ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  bool _isLoading = false;

  userMessage(String createdAt, int index, String message) {
    return types.TextMessage(
        author: userMe,
        id: index.toString(),
        text: message
    );
  }

  aiMessage(String createdAt, int index, String message) {
    return types.TextMessage(
        author: userAI,
        id: index.toString(),
        text: message
    );
  }
  final chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _loadInitialHistory();
  }

  Future<void> _loadInitialHistory() async {
    final idToken = sharedPreferencesManager.getIdToken();
    if(idToken == null) return;
    List<types.Chat>? chats;
    try {
      chats = await chatService.getNextHistory(idToken);
    } catch (e) {
      if(!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('認証情報の有効期限が切れたため、再度ログインしてください。')),
      );
    }
    if(chats == null) return;
    final reversed = chats.reversed.toList();
    if (!mounted) return;
    setState(() {
      for (var chat in reversed) {
        if(chat.type == "ai") {
          _addMessageToStart(aiMessage(chat.dateTime,chat.index, chat.message));
        } else {
          _addMessageToStart(userMessage(chat.dateTime,chat.index, chat.message));
        }
      }
    });
  }

  Future<void> _loadPreviousHistory() async {
    if (_isLoading) {
      return;
    }
    if(!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final idToken = sharedPreferencesManager.getIdToken();
      final chats = await chatService.getNextHistory(idToken!);
      final reversed = chats?.reversed.toList();
      if(!mounted) return;
      setState(() {
        reversed?.forEach((chat) {
          if(chat.type == "ai") {
            _addMessageToEnd(aiMessage(chat.dateTime,chat.index, chat.message));
          } else {
            _addMessageToEnd(userMessage(chat.dateTime, chat.index, chat.message));
          }
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    body: Chat(
      user: userMe,
      messages: _messages,
      onSendPressed: _handleSendPressed,
      showUserNames: true,
      onEndReached: _loadPreviousHistory,
    ),
  );

  void _addMessageToEnd(types.Message message) {
    if(!mounted) return;
    setState(() {
      _messages.add(message);
    });
  }

  void _addMessageToStart(types.Message message) {
    if(!mounted) return;
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final idToken = sharedPreferencesManager.getIdToken();
    _addMessageToStart(userMessage(DateTime.now().toString(), _messages.length + 1, message.text));
    final response = await chatService.sendChat(idToken!, message.text);
    _addMessageToStart(aiMessage(DateTime.now().toString(), _messages.length + 1, response.message));
  }
}