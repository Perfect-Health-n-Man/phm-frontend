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
    final goals = json['goals'].map<String>((e)  {
      return e as String;
    }).toList();
    return User(
        json['email'],
        json['name'],
        goals,
        DateTime.parse(json['birthday']),
        double.parse(json['height']),
        double.parse(json['weight']),
        json['gender']
    );
  }
}