class VefiryModel {
  final String message;

  VefiryModel({required this.message});

  /// 🧩 Create a model from JSON
  factory VefiryModel.fromJson(Map<String, dynamic> json) {
    return VefiryModel(message: json['message'] ?? '');
  }

  /// 🔁 Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
