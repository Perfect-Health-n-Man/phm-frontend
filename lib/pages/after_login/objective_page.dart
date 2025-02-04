import 'package:flutter/material.dart';
import 'package:phm_frontend/main.dart';
import 'package:phm_frontend/pages/after_login/objective_tutorial_page.dart';
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
  bool _showTutorial = sharedPreferencesManager.getIsFirstLogin();

  @override
  void initState(){
    super.initState();
    Future(() async {
      await _loadPreferences();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _goalControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final user = sharedPreferencesManager.getUserData();
    if (user == null) {
      sharedPreferencesManager.setIsFirstLogin(true);
    } else {
      await sharedPreferencesManager.setIsFirstLogin(false);
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
  }

  void _onPressedRegisterButton() async {
    final token = sharedPreferencesManager.getIdToken();
    final previousEmail = sharedPreferencesManager.getLoginEmail();
    if (previousEmail == null) return;
    final email = previousEmail;
    final name = _nameController.text;
    final goals = _goalControllers.map((c) => c.text.toString()).toList();
    final birthday = _birthday;
    final height = _height;
    final weight = _weight;
    final gender = _selectedGender ?? '';

    if (token == null || email == "") {
      return;
    }
    final user = User(email, name, goals, birthday, height, weight, gender);
    await createUser(token, user);
    sharedPreferencesManager.setUserData(user);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('登録が完了しました')),
    );
    sharedPreferencesManager.setIsFirstLogin(false);
  }

  void onDoneTutorial() {
    setState(() {
      _showTutorial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showTutorial) {
      return ObjectiveTutorialPage(onDonePress: onDoneTutorial);
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('目標とプロフィール'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
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
                _buildSectionTitle('名前'),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: '名前を入力してください',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 20),

                _buildSectionTitle('目標'),
                ..._goalControllers.map((controller) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: '目標を入力してください',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
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

                _buildSectionTitle('誕生日'),
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: Text('${_birthday.year}/${_birthday.month}/${_birthday.day}'),
                ),
                const SizedBox(height: 20),

                _buildSectionTitle('性別'),
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
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 20),

                _buildSectionTitle('身長'),
                _buildSliderWithLabel(_height, 100, 220, 'cm'),
                const SizedBox(height: 20),

                _buildSectionTitle('体重'),
                _buildSliderWithLabel(_weight, 30, 150, 'kg'),
                const SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: _onPressedRegisterButton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onTertiary,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSliderWithLabel(double value, double min, double max, String unit) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: (double newValue) {
              setState(() {
                if (unit == 'cm') {
                  _height = newValue;
                } else if (unit == 'kg') {
                  _weight = newValue;
                }
              });
            },
          ),
        ),
        Text('${value.toStringAsFixed(1)}$unit'),
      ],
    );
  }
}