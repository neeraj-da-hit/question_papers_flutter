class RegisterModel {
  final String message;

  RegisterModel({required this.message});

  /// 🧩 Create a model from JSON
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(message: json['message'] ?? '');
  }

  /// 🔁 Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
