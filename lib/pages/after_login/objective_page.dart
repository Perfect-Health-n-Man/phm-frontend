import 'package:flutter/material.dart';
import 'package:phm_frontend/main.dart';
import 'package:phm_frontend/repository/user.dart';

import '../../models/user_model.dart';

class ObjectivePage extends StatefulWidget {
  const ObjectivePage({super.key});

  @override
  State<ObjectivePage> createState() => _ObjectivePageState();
}

class _ObjectivePageState extends State<ObjectivePage> {
  final _nameController = TextEditingController();
  final _goalControllers = <TextEditingController>[TextEditingController()];
  DateTime _birthday = DateTime.now();
  double _height = 170.0;
  double _weight = 60.0;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _goalControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _loadPreferences() async {
    final user = sharedPreferencesManager.getUserData();
    if(user == null) return;
    setState(() {
      _nameController.text = user.name;
      final goals = user.goals;
      _goalControllers.clear();
      _goalControllers.addAll(goals.map((goal) => TextEditingController(text: goal)));
      _height = user.height;
      _weight = user.weight;
      _selectedGender = user.gender;
      final birthdayString = user.birthDay.toIso8601String();
      _birthday = DateTime.parse(birthdayString);
    });
  }

  void _onPressedRegisterButton() async {
    final token = sharedPreferencesManager.getIdToken();
    final previousEmail = sharedPreferencesManager.getLoginEmail();
    if(previousEmail == null) return;
    final email = previousEmail;
    final name = _nameController.text;
    final goals = _goalControllers.map((c) => c.text.toString()).toList();
    final birthday = _birthday;
    final height = _height;
    final weight = _weight;
    final gender = _selectedGender ?? '';

    if(token == null || email == "") {
      return;
    }
      final user = User(email, name, goals, birthday, height, weight, gender);
      await createUser(token, user);
      sharedPreferencesManager.setUserData(user);

      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('登録が完了しました')),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目標設定'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '名前',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: '名前を入力してください',
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                '目標',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._goalControllers.map((controller) => Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: '目標を入力してください',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _goalControllers.add(TextEditingController());
                  });
                },
                child: const Text('目標を追加'),
              ),
              const SizedBox(height: 20),

              const Text(
                '誕生日',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _birthday,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != _birthday) {
                    setState(() {
                      _birthday = picked;
                    });
                  }
                },
                child: Text('${_birthday.year}/${_birthday.month}/${_birthday.day}'),
              ),
              const SizedBox(height: 20),

              const Text(
                '性別',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: <String>['男性', '女性', 'その他']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  hintText: '性別を選択してください',
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                '身長',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _height,
                      min: 100,
                      max: 220,
                      divisions: 120,
                      onChanged: (double value) {
                        setState(() {
                          _height = value;
                        });
                      },
                    ),
                  ),
                  Text('${_height.toStringAsFixed(1)}cm'),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                '体重',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _weight,
                      min: 30,
                      max: 150,
                      divisions: 120,
                      onChanged: (double value) {
                        setState(() {
                          _weight = value;
                        });
                      },
                    ),
                  ),
                  Text('${_weight.toStringAsFixed(1)}kg'),
                ],
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _onPressedRegisterButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('登録'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}