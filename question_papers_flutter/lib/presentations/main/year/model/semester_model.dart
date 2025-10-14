class SemesterModel {
  final String id;
  final String course;
  final String name;
  final int v; // corresponds to "__v"

  SemesterModel({
    required this.id,
    required this.course,
    required this.name,
    required this.v,
  });

  // Create from Map (JSON → Dart)
  factory SemesterModel.fromMap(Map<String, dynamic> map) {
    return SemesterModel(
      id: map['_id'] ?? '',
      course: map['course'] ?? '',
      name: map['name'] ?? '',
      v: map['__v'] ?? 0,
    );
  }

  // Convert to Map (Dart → JSON)
  Map<String, dynamic> toMap() {
    return {'_id': id, 'course': course, 'name': name, '__v': v};
  }

  // JSON convenience methods
  factory SemesterModel.fromJson(Map<String, dynamic> json) =>
      SemesterModel.fromMap(json);
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() =>
      'SemesterModel(id: $id, course: $course, name: $name, v: $v)';
}
