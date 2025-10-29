import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:question_papers_flutter/core/permission/service/permission_service.dart';

class PermissionController extends GetxController {
  var cameraGranted = false.obs;
  var locationGranted = false.obs;
  var storageGranted = false.obs;

  /// Generic request
  Future<bool> requestPermission(Permission permission) async {
    final granted = await PermissionService.requestPermission(permission);
    _updatePermission(permission, granted);

    if (!granted) {
      await PermissionService.openSettingsIfPermanentlyDenied(permission);
    }

    return granted;
  }

  /// Request multiple at once
  Future<void> requestAll() async {
    final results = await PermissionService.requestMultiple([
      Permission.camera,
      Permission.locationWhenInUse,
      Permission.storage,
    ]);

    results.forEach((perm, status) {
      _updatePermission(perm, status.isGranted);
    });
  }

  void _updatePermission(Permission permission, bool granted) {
    if (permission == Permission.camera) {
      cameraGranted.value = granted;
    } else if (permission == Permission.locationWhenInUse) {
      locationGranted.value = granted;
    } else if (permission == Permission.storage) {
      storageGranted.value = granted;
    }
  }
}
