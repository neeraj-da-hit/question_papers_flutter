class ForgotPsdModel {
  final String message;

  ForgotPsdModel({required this.message});

  /// 🧩 Create a model from JSON
  factory ForgotPsdModel.fromJson(Map<String, dynamic> json) {
    return ForgotPsdModel(message: json['message'] ?? '');
  }

  /// 🔁 Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
