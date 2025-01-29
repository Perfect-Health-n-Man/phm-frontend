import 'package:flutter/material.dart';
import 'login_page.dart';
import 'account_creation_page.dart';

class InitialQuestionPage extends StatelessWidget {
  const InitialQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ようこそ'),
        automaticallyImplyLeading: false
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'あなたはこのアプリを使うのが初めてですか？',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: FilledButton(
                    onPressed: () {
                      // アカウント作成画面に遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountCreationPage()),
                      );
                    },
                    child: const Text('はい'),
                  ),
                  ),
                  Expanded(child: FilledButton.tonal(
                    onPressed: () {
                      // ログイン画面に遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text('いいえ'),
                  ),
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}