import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:question_papers_flutter/presentations/auth/login/controller/login_controller.dart';
import 'package:question_papers_flutter/presentations/auth/login/screen/login_screen.dart';

class ProfielScreen extends StatelessWidget {
  const ProfielScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
  onPressed: () async {
    final loginController = Get.find<LoginController>();
    await loginController.logout();

    // Logout ke baad login screen pe redirect karna hai
    Get.offAll(() => LoginScreen());
  },
  child: const Text("Logout"),
),
      ),
    );
  }
}