import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:phm_frontend/main.dart';
import 'package:phm_frontend/models/message_model.dart' as types;
import 'package:phm_frontend/utils/to_message.dart';
import '../../service/chat_service.dart';
import '../../widget/custom_message_builder.dart';
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
  bool _isAIThinking = false;

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
    _loadInitialHistory();
  }

  Future<void> _loadInitialHistory() async {
    final idToken = sharedPreferencesManager.getIdToken();
    if (idToken == null) return;
    List<types.Chat>? chats;
    try {
      chats = await chatService.getNextHistory(idToken);
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
    if (chats == null) return;
    final reversed = chats.reversed.toList();
    if (!mounted) return;

    setState(() {
      for (var chat in reversed) {
        if (chat.type == "ai") {
          _addMessageToStart(
              aiMessage(chat.dateTime, chat.index, chat.message));
        } else {
          _addMessageToStart(
              userMessage(chat.dateTime, chat.index, chat.message));
        }
      }
    });
  }

  Future<void> _loadPreviousHistory() async {
    if (_isLoading) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final idToken = sharedPreferencesManager.getIdToken();
      final chats = await chatService.getNextHistory(idToken!);
      final reversed = chats?.reversed.toList();
      if (!mounted) return;

      setState(() {
        reversed?.forEach((chat) {
          if (chat.type == "ai") {
            _addMessageToEnd(
                aiMessage(chat.dateTime, chat.index, chat.message));
          } else {
            _addMessageToEnd(
                userMessage(chat.dateTime, chat.index, chat.message));
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
  Widget build(BuildContext context) => Chat(
        user: userMe,
        messages: _messages,
        onSendPressed: _handleSendPressed,
        showUserNames: true,
        onEndReached: _loadPreviousHistory,
        customMessageBuilder: (types.CustomMessage customMessage,
                {required int messageWidth}) =>
            customMessageBuilder(customMessage,
                messageWidth: messageWidth,
                onPressedAnswer: onPressedAnswerButton),
        theme: DefaultChatTheme(
          primaryColor: Theme.of(context).colorScheme.primary, // メッセージの背景色の変更
          userAvatarNameColors: [Colors.green], // ユーザー名の文字色の変更
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

  Future<void> onPressedAnswerButton(
      List<String> questions, List<String> answers) async {
    final idToken = sharedPreferencesManager.getIdToken();
    if (idToken == null) return;
    _messages.removeAt(0);
    _addMessageToStart(aiMessage(DateTime.now().toString(),
        _messages.length + 1, listToMessage(questions)));
    _addMessageToStart(userMessage(DateTime.now().toString(),
        _messages.length + 1, listToMessage(answers)));
    _addMessageToStart(
        aiThinking(DateTime.now().toString(), _messages.length + 1));
    try {
      final response =
          await chatService.sendFormAnswer(idToken, questions, answers);
      _messages.removeAt(0);
      _addMessageToStart(aiMessage(
          DateTime.now().toString(), _messages.length + 1, response.answer));
      final forms = response.forms;
      if (forms != null) {
        _addMessageToStart(aiForm(
            DateTime.now().toString(), _messages.length + 1, forms.questions));
      }
    } finally {
      setState(() {
        _isAIThinking = false;
      });
    }
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final idToken = sharedPreferencesManager.getIdToken();

    setState(() {
      _isAIThinking = true;
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
      final forms = response.forms;
      if (forms != null) {
        _addMessageToStart(aiForm(
            DateTime.now().toString(), _messages.length + 1, forms.questions));
      }
    } catch (e) {
      _messages.removeAt(0);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('エラーが発生しました。再度お試しください。')),
      );
    } finally {
      setState(() {
        _isAIThinking = false;
      });
    }
  }
}
