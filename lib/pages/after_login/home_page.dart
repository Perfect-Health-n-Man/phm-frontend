import 'package:flutter/material.dart';
import 'package:phm_frontend/main.dart';
import 'package:phm_frontend/pages/after_login/chat_page.dart';
import 'package:phm_frontend/pages/after_login/objective_page.dart';
import 'package:phm_frontend/pages/after_login/setting_page.dart';
import 'package:phm_frontend/pages/after_login/task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  var _currentPageIndex = sharedPreferencesManager.getUserData() == null ? 2 : 0;

  final _pages = <Widget>[
    ChatPage(),
    TaskListPage(),
    ObjectivePage(),
    SettingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentPageIndex]),
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) async {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        animationDuration: const Duration(seconds: 10),
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.chat), label: 'AIチャット'),
          NavigationDestination(
              icon: Icon(Icons.task), label: 'タスク'),
          NavigationDestination(
              icon: Icon(Icons.golf_course), label: '目標とプロフィール'),
          NavigationDestination(
              icon: Icon(Icons.account_circle_sharp), label: 'アカウント'),

        ],),
    );
  }
}