class User {
  String email;
  String name;
  String gender;
  List<String> goals;
  DateTime birthDay;
  double height;
  double weight;

  User(this.email, this.name, this.goals, this.birthDay, this.height,
      this.weight, this.gender);
  static fromJson(Map<String, dynamic> json) {
    final userInfo = json['user_info'];
    final goals = (userInfo['goals'] as List).map((e) => e as String).toList();
    return User(
      userInfo['email'],
      userInfo['name'],
      goals,
      DateTime.parse(userInfo['birthday']),
      double.parse(userInfo['height']),
      double.parse(userInfo['weight']),
      userInfo['gender'],
    );
  }
}