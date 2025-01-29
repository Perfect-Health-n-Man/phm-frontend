import 'package:flutter/material.dart';
import 'package:phm_frontend/main.dart';
import 'package:phm_frontend/pages/before_login/initial_question_page.dart';
import 'package:phm_frontend/pages/before_login/login_page.dart';
import 'package:phm_frontend/service/firebase_service.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final _firebaseService = FirebaseService();

  Future<void> _onPressedLogoutButton(BuildContext context) async {
      await _firebaseService.logout();
      await sharedPreferencesManager.clear();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()),
      );
  }

  Future<void> _onPressedAccountDeleteButton(BuildContext context) async{
    await _firebaseService.deleteAccount();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InitialQuestionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text("設定"),
          automaticallyImplyLeading: false
        ),
        SettingsList(
          shrinkWrap: true,
          sections: [
            SettingsSection(
              title: const Text('Common'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.logout),
                  title: const Text('ログアウト'),
                  onPressed: (context) => _onPressedLogoutButton(context)
                ),
                SettingsTile.navigation(
                    leading: const Icon(Icons.delete),
                  title: const Text('アカウント削除'),
                  onPressed: (context) => _onPressedAccountDeleteButton(context)
                )
              ]
            ),
          ]
        ),
      ],
    );
  }
}