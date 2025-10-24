class LoginResponse {
  final String message;
  final String token;
  final UserModel user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'token': token,
    'user': user.toJson(),
  };
}

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
