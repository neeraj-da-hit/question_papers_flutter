class AppVersionModel {
  final String appId;
  final String appName;
  final String version;
  final bool updateRequired;
  final String message;

  AppVersionModel({
    required this.appId,
    required this.appName,
    required this.version,
    required this.updateRequired,
    required this.message,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};
    return AppVersionModel(
      appId: data["app_id"] ?? "",
      appName: data["app_name"] ?? "",
      version: data["version"] ?? "",
      updateRequired: json["update_required"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
