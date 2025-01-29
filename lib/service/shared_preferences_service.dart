import 'package:phm_frontend/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  late SharedPreferences prefs;
  SharedPreferencesManager(this.prefs) {
    prefs = prefs;
  }

  User? getUserData() {
    final name = prefs.getString('name');
    final goals = prefs.getStringList('goals');
    final birthDay = prefs.getString('birthday');
    final height = prefs.getDouble('height');
    final weight = prefs.getDouble('weight');
    final gender = prefs.getString('gender');
    final email = prefs.getString('email');
    if(name == null || goals == null || birthDay == null || height == null || weight == null || gender == null || email == null) {
     return null;
    }
    return User(email, name, goals, DateTime.parse(birthDay), height, weight, gender);
  }

  Future<void> setUserData(User user) async {
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setStringList('goals', user.goals);
    await prefs.setString('birthday', user.birthDay.toIso8601String());
    await prefs.setDouble('height', user.height);
    await prefs.setDouble('weight', user.weight);
    await prefs.setString('gender', user.gender);
  }

  bool getIsLoggedIn()  {
    return prefs.getBool("isLoggedIn") ?? false;
  }

  Future<void> setIsLoggedIn(bool isLoggedIn) async {
   await prefs.setBool("isLoggedIn", isLoggedIn);
  }

  String? getIdToken()  {
    return prefs.getString("idToken");
  }

  Future<void> setIdToken(String idToken) async {
    await prefs.setString("idToken", idToken);
  }

  String? getLoginEmail()  {
    return prefs.getString("loginEmail");
  }

  Future<void> setLoginEmail(String loginEmail) async {
    await prefs.setString("loginEmail", loginEmail);
  }

  Future<void> clear() async {
    await prefs.clear();
  }

}