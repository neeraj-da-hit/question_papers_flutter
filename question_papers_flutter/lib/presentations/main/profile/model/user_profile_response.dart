class UserProfileResponse {
  final UserProfile user;

  UserProfileResponse({required this.user});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(user: UserProfile.fromJson(json['user']));
  }

  Map<String, dynamic> toJson() => {'user': user.toJson()};
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final bool isVerified;
  final String course;
  final int phone;
  final bool isResetVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
    required this.course,
    required this.phone,
    required this.isResetVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      isVerified: json['is_verified'],
      course: json['course'],
      phone: json['phone'],
      isResetVerified: json['is_reset_verified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'is_verified': isVerified,
    'course': course,
    'phone': phone,
    'is_reset_verified': isResetVerified,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}
