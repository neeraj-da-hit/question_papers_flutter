class NewPasswordModel {
  final String message;

  NewPasswordModel({required this.message});

  /// 🧩 Create a model from JSON
  factory NewPasswordModel.fromJson(Map<String, dynamic> json) {
    return NewPasswordModel(message: json['message'] ?? '');
  }

  /// 🔁 Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
