class UserProfileResponse {
  final UserProfile? user;

  UserProfileResponse({this.user});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      user: json['user'] != null ? UserProfile.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {'user': user?.toJson()};
}

class UserProfile {
  final String? id;
  final String? name;
  final String? email;
  final bool? isVerified;
  final String? course;
  final int? phone;
  final bool? isResetVerified;
  final String? profilePic;
  final String? profilePublicId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  UserProfile({
    this.id,
    this.name,
    this.email,
    this.isVerified,
    this.course,
    this.phone,
    this.isResetVerified,
    this.profilePic,
    this.profilePublicId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      isVerified: json['is_verified'] as bool?,
      course: json['course'] as String?,
      phone: json['phone'] is int
          ? json['phone']
          : int.tryParse(json['phone']?.toString() ?? ''),
      isResetVerified: json['is_reset_verified'] as bool?,
      profilePic: json['profilePic'] as String?,
      profilePublicId: json['profilePublicId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] as int?,
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
    'profilePic': profilePic,
    'profilePublicId': profilePublicId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}
