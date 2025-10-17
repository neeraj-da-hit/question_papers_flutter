import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/app_version_model.dart';
import 'package:flutter/foundation.dart';

class SplashService {
  Future<AppVersionModel> checkAppVersion(String appId, String version) async {
    final body = jsonEncode({"app_id": appId, "version": version});
    final url = Uri.parse("https://app-version-controll.onrender.com/apps/check-version");

    if (kDebugMode) print("🔹 Sending version check request: $body");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (kDebugMode) print("🔹 Response: ${response.body}");

    final data = jsonDecode(response.body);
    return AppVersionModel.fromJson(data);
  }
}
