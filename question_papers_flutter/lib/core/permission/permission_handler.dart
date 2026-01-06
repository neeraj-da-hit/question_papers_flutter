import 'package:permission_handler/permission_handler.dart';

Future<bool> requestGalleryPermission() async {
  final status = await Permission.photos.request();
  return status.isGranted;
}
