class MyProfile {
  int? id;
  String? avatarUrl;
  String? firstname;
  String? lastname;
  String? nickname;
  int? level;

  MyProfile(
      {this.id,
      this.avatarUrl,
      this.firstname,
      this.lastname,
      this.nickname,
      this.level});

  static fromJson(Map<String, dynamic> json) {
    return MyProfile(
      avatarUrl: json["avatarUrl"] ?? "",
      firstname: json["firstname"] ?? "",
      id: json["id"] ?? -1,
      lastname: json["lastname"] ?? "",
      nickname: json["nickname"] ?? "",
      level: json["level"] ?? 0,
    );
  }
}
