import 'package:flutter/material.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    // TODO: サーバーからタスクを取得する処理を実装
    if(!mounted) return;
    setState(() {
      _tasks = ['タスク1', 'タスク2', 'タスク3'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タスクリスト'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView( // SingleChildScrollViewで囲む
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'タスク',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _tasks.isEmpty // タスクが空の場合の処理
                  ? const Center(child: Text('タスクはありません'))
                  : ListView.builder( // ListView.builderでタスクを表示
                shrinkWrap: true, // これがないとエラーが出る可能性あり
                physics: const NeverScrollableScrollPhysics(), // これがないとエラーが出る可能性あり
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card( // Cardでタスクを囲むと見やすい
                    child: ListTile(
                      title: Text(task),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}