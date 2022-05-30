class User {
  int? id;
  String? avatarUrl;

  User({this.id, this.avatarUrl});

  static User fromJson(Map<String, dynamic> json) {
    return User(id: json['account_id'], avatarUrl: json['avatarUrl']);
  }
}
