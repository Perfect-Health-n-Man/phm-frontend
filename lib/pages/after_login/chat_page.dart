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
  bool loading = false;
  bool end = false;

  userMessage(String createdAt, int index, String message) {
    return types.TextMessage(
        author: userMe, id: index.toString(), text: message);
  }

  aiMessage(String createdAt, int index, String message) {
    return types.TextMessage(
        author: userAI, id: index.toString(), text: message);
  }

  aiForm(String createdAt, int index, List<String> questions) {
    return types.CustomMessage(author: userAI, id: index.toString(), metadata: {
      "questions": questions,
    });
  }

  aiThinking(String createdAt, int index) {
    return types.TextMessage(
        author: userAI, id: index.toString(), text: "考え中です...");
  }

  final chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if(loading || end) return;
    setState(() {
      loading = true;
    });
    final idToken = sharedPreferencesManager.getIdToken();
    final page = _messages.length ~/ ChatService.getChatHistoryNum + 1;
    print(page);
    if (idToken == null) return;
    List<types.Chat>? chats;
    try {
      chats = await chatService.getNextHistory(idToken, page);
    } catch (e) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('認証情報の有効期限が切れたため、再度ログインしてください。')),
      );
    }
    if (!mounted) return;
    // get chat index max
    if (chats == null) return;
    if(chats.length < 10) end = true;
    final max = chats.map((chat) => chat.index).reduce((a, b) => a > b ? a : b);

    setState(() {
        for (var chat in chats!) {
          print("max: $max");
          print("index: ${chat.index}");
          if(chat.index > max) continue;
          if (chat.type == "ai") {
            _addMessageToEnd(
                aiMessage(chat.dateTime, chat.index, chat.message));
          } else {
            _addMessageToEnd(
                userMessage(chat.dateTime, chat.index, chat.message));
          }
        }
        loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Chat(
        user: userMe,
        messages: _messages,
        onSendPressed: _handleSendPressed,
        showUserNames: true,
        onEndReached: _loadHistory,
        theme: DefaultChatTheme(
          primaryColor: Theme.of(context).colorScheme.primary,
          userAvatarNameColors: [Colors.green],
          backgroundColor: Colors.transparent,
          inputBackgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );

  void _addMessageToEnd(types.Message message) {
    if (!mounted) return;
    setState(() {
      _messages.add(message);
    });
  }

  void _addMessageToStart(types.Message message) {
    if (!mounted) return;

    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final idToken = sharedPreferencesManager.getIdToken();
    setState(() {
      loading = true;
    });

    _addMessageToStart(userMessage(
        DateTime.now().toString(), _messages.length + 1, message.text));
    _addMessageToStart(
        aiThinking(DateTime.now().toString(), _messages.length + 1));
    try {
      final response = await chatService.sendChat(idToken!, message.text);
      _messages.removeAt(0);
      _addMessageToStart(aiMessage(
          DateTime.now().toString(), _messages.length + 1, response.answer));
    } catch (e) {
      _messages.removeAt(0);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('エラーが発生しました。再度お試しください。')),
      );
      setState(() {
        loading = false;
      });

    }
    setState(() {
      loading = false;
    });

  }
}
