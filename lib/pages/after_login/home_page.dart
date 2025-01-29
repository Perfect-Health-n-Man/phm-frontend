import 'package:flutter/material.dart';
import 'package:phm_frontend/pages/after_login/chat_page.dart';
import 'package:phm_frontend/pages/after_login/objective_page.dart';
import 'package:phm_frontend/pages/after_login/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}
class _HomePageState extends State<HomePage> {
  var _currentPageIndex = 0;

  final _pages = <Widget>[
    ChatPage(),
    ObjectivePage(),
    SettingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentPageIndex]),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        animationDuration: const Duration(seconds: 10),
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.chat), label: 'チャット'),
          NavigationDestination(
              icon: Icon(Icons.content_copy), label: '目標'),
          NavigationDestination(
              icon: Icon(Icons.settings), label: '設定'),
        ],),
    );
  }
}