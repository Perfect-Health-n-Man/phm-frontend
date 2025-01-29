import 'package:flutter/material.dart';
import 'package:phm_frontend/main.dart';
import 'package:phm_frontend/pages/after_login/home_page.dart';
import 'package:phm_frontend/pages/before_login/account_creation_page.dart';
import 'package:phm_frontend/repository/user.dart';
import 'package:phm_frontend/service/firebase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseService = FirebaseService();

  Future<void> _onPressedLoginButton() async {
    if (!_formKey.currentState!.validate()) return;
    final result = await _firebaseService.login(
        _emailController.text, _passwordController.text);
    if(result) {
      sharedPreferencesManager.setIsLoggedIn(true);
      final currentEmail = sharedPreferencesManager.getUserData()?.email;
      if(currentEmail != _emailController.text) await sharedPreferencesManager.clear();
      sharedPreferencesManager.setLoginEmail(_emailController.text);
      final idToken = await _firebaseService.getIDToken();
      if(idToken == null) return;
      sharedPreferencesManager.setIdToken(idToken);
      final user = await getUser(idToken);
      if(user == null) return;
      await sharedPreferencesManager.setUserData(user);
      if(!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage()),
      );

    } else {
      if(!mounted) return;
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('ログインに失敗しました。メールアドレスかパスワード、またはその両方が間違っています。'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text('もう一度'),
                ),
              ],
            );
          }
      );
    }
  }

  void _onPressedAccountCreationButton() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const AccountCreationPage()),
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
        title: const Text('ログイン'),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: _onPressedAccountCreationButton,
                          child: const Text('アカウント作成へ'),

                      ),
                      ElevatedButton(
                        onPressed: _onPressedLoginButton,
                        child: const Text('ログイン'),
                      ),
                    ],
                  )
                ,
              )
            ],
          ),
        ),
      ),
    );
  }
}