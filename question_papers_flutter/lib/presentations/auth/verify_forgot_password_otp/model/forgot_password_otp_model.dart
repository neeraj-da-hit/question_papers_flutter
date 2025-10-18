class ForgotPasswordOtpModel {
  final String message;

  ForgotPasswordOtpModel({required this.message});

  /// 🧩 Create a model from JSON
  factory ForgotPasswordOtpModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordOtpModel(message: json['message'] ?? '');
  }

  /// 🔁 Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
