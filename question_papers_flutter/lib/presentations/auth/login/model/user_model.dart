class UserModel {
  final String id;
  final String name;
  final String email;
  final int phone;
  final String course;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.course,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      course: json['course'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'course': course,
  };
}
