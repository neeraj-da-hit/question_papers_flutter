class CourseModel {
  final String id;
  final String name;
  final int version;

  CourseModel({required this.id, required this.name, required this.version});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      version: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "name": name, "__v": version};
  }
}
