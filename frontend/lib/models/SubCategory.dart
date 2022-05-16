class SubCategory {
  late int id;
  late String subType;

  SubCategory({required this.id, required this.subType});

  // ดึกจาก json ทีละตัวนะ
  static SubCategory fromJson(Map<String, dynamic> event) {
    return SubCategory(
      id: event["id"],
      subType: event["subType"],
    );
  }

  toJson() {
    return {
      "id": id,
      "subType": subType,
    };
  }
}
