import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../model/app_version_model.dart';
import '../service/splash_service.dart';
import 'package:flutter/foundation.dart';

class SplashController extends GetxController {
  final SplashService _service = SplashService();

  var appVersion = AppVersionModel(
    appId: "",
    appName: "",
    version: "",
    updateRequired: false,
    message: "",
  ).obs;

  var isLoading = true.obs;

  Future<void> checkVersion() async {
    try {
      isLoading.value = true;

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (kDebugMode) print("📦 Current App Version: $currentVersion");

      final result = await _service.checkAppVersion(
        "69022e990bf9df4bcb578c5f",
        currentVersion,
      );

      if (kDebugMode) {
        print("✅ Server Version: ${result.version}");
        print("⚠️ Update Required: ${result.updateRequired}");
        print("💬 Message: ${result.message}");
      }

      appVersion.value = result;
    } catch (e) {
      if (kDebugMode) print("❌ Version check failed: $e");

      appVersion.value = AppVersionModel(
        appId: "",
        appName: "",
        version: "",
        updateRequired: false,
        message: "Failed to check version. Please try again.",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
