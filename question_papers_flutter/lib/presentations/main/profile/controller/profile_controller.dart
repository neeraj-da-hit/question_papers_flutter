// lib/presentations/main/profile/controller/profile_controller.dart
import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/auth/login/controller/login_controller.dart';
import 'package:question_papers_flutter/presentations/auth/login/screen/login_screen.dart';

class ProfileController extends GetxController {
  final LoginController _loginController = Get.find<LoginController>();

  Future<void> logout() async {
    await _loginController.logout(); // call your existing logout logic
    Get.offAll(() => LoginScreen()); // navigate to login
  }
}
