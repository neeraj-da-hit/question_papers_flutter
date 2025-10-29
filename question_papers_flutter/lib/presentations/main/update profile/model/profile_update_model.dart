class ProfileUpdateModel {
  final String message;
  final User user;

  ProfileUpdateModel({required this.message, required this.user});

  factory ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateModel(
      message: json['message'] ?? '',
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'user': user.toJson()};
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final bool isVerified;
  final String? course;
  final int? phone;
  final bool isResetVerified;
  final String? profilePic;
  final String? profilePublicId;
  final String createdAt;
  final String updatedAt;
  final int v;
  final int? otp;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isVerified,
    this.course,
    this.phone,
    required this.isResetVerified,
    this.profilePic,
    this.profilePublicId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.otp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      isVerified: json['is_verified'] ?? false,
      course: json['course'],
      phone: json['phone'],
      isResetVerified: json['is_reset_verified'] ?? false,
      profilePic: json['profilePic'],
      profilePublicId: json['profilePublicId'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      otp: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'is_verified': isVerified,
      'course': course,
      'phone': phone,
      'is_reset_verified': isResetVerified,
      'profilePic': profilePic,
      'profilePublicId': profilePublicId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'otp': otp,
    };
  }
}
