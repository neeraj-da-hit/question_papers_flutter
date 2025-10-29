import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Request a single permission
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    final result = await permission.request();
    return result.isGranted;
  }

  /// Request multiple permissions
  static Future<Map<Permission, PermissionStatus>> requestMultiple(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  /// Open app settings if permanently denied
  static Future<void> openSettingsIfPermanentlyDenied(
    Permission permission,
  ) async {
    final status = await permission.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
