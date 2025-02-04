import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

Widget customMessageBuilder(
  CustomMessage customMessage, {
  required int messageWidth,
  required void Function(List<String>, List<String>) onPressedAnswer,
}) {
  final questions =
      customMessage.metadata?["questions"] as List<dynamic>; // 安全なキャストとnullチェック
  if (questions.isEmpty) {
    return const Text("質問がありません"); // 質問がない場合の表示
  }

  final answersControllers =
      List.generate(questions.length, (_) => TextEditingController());

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
      children: <Widget>[
        ...List.generate(questions.length, (index) {
          final question = questions[index];
          final answerController = answersControllers[index];
          return Padding(
            // 各質問の間隔を調整
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 質問を左寄せ
              children: [
                Text(
                  question.toString(), // toString()でStringに変換
                  style: const TextStyle(fontWeight: FontWeight.bold), // 質問を太字に
                ),
                const SizedBox(height: 4), // 質問とTextFieldの間隔
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    hintText: "回答を入力",
                    contentPadding: const EdgeInsets.symmetric(
                      // TextFieldのパディング
                      vertical: 8,
                      horizontal: 12,
                    ),
                  ),
                  controller: answerController,
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16), // ボタンと質問の間隔
        Align(
          // ボタンを右寄せ
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              final answers = answersControllers.map((controller) => controller.text).toList();
              final questionsString = questions.map((question) => question.toString()).toList();
              onPressedAnswer(questionsString, answers);
            },
            child: const Text("回答"),
          ),
        ),
      ],
    ),
  );
}
