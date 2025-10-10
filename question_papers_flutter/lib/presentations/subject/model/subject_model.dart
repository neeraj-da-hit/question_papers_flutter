class SubjectModel {
  final String id;
  final String semester;
  final String name;
  final int v;

  SubjectModel({
    required this.id,
    required this.semester,
    required this.name,
    required this.v,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['_id'] ?? '',
      semester: json['semester'] ?? '',
      name: json['name'] ?? '',
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'semester': semester, 'name': name, '__v': v};
  }

  static List<SubjectModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => SubjectModel.fromJson(json)).toList();
  }
}
