import 'package:flutter/material.dart';
import 'package:phm_frontend/pages/before_login/login_page.dart';
import 'package:phm_frontend/service/firebase_service.dart';

class AccountCreationPage extends StatefulWidget {
  const AccountCreationPage({super.key});

  @override
  State<AccountCreationPage> createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> onPressedAccountCreationButton() async {
    if (!_formKey.currentState!.validate()) {return;}
    await _firebaseService.register(
        _emailController.text, _passwordController.text);
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const LoginPage()),
    );
  }

  void onPressedLoginPageButton()  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント作成'),
        automaticallyImplyLeading: false

      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'メールアドレス',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '入力してください';
                  }
                  if (!value.contains('@')) {
                    return '有効なメールアドレスを入力してください';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'パスワード',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '入力してください';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,20,0),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: onPressedAccountCreationButton,
                      child: const Text('アカウント作成'),
                    ),
                    ElevatedButton(
                        onPressed: onPressedLoginPageButton,
                        child: const Text('ログインページへ')
                    )
                  ],
                )
                ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}