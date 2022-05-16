class Event {
  late int id;
  late int host_id;
  late String title;
  late String location;
  late String detail;
  late String gender;
  late DateTime eventDate;
  late int subType_id;
  late int minAge;
  late int maxAge;
  late int maxJoin;
  late int awesome;
  late String host;
  late int joined;
  late String eventImageUrl;
  late String hostAvatarUrl;
  late String subType_name;

  Event(
      {required this.id,
      required this.host_id,
      required this.title,
      required this.location,
      required this.detail,
      required this.awesome,
      required this.eventDate,
      required this.gender,
      required this.maxAge,
      required this.maxJoin,
      required this.minAge,
      required this.subType_id,
      required this.joined,
      required this.host,
      required this.eventImageUrl,
      required this.hostAvatarUrl,
      required this.subType_name});

  // ดึกจาก json ทีละตัวนะ
  static Event fromJson(Map<String, dynamic> event) {
    return Event(
        id: event["id"],
        awesome: event["awesome"],
        detail: event["detail"],
        eventDate: DateTime.parse(event["eventDate"]),
        gender: event["gender"],
        location: event["location"],
        maxAge: event["maxAge"],
        maxJoin: event["maxJoin"],
        minAge: event["minAge"],
        title: event["title"],
        host_id: event["host_id"],
        subType_id: event["subType_id"],
        host: event["host"],
        joined: event["joined"],
        eventImageUrl: event["eventImageUrl"],
        hostAvatarUrl: event["hostAvatarUrl"],
        subType_name: event["subType_name"]);
  }
}
