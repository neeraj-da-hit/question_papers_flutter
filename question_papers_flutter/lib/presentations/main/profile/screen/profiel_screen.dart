// lib/presentations/main/profile/screen/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/main/profile/controller/profile_controller.dart';
import 'package:question_papers_flutter/presentations/main/profile/widgets/logout_dialog_box.dart';

class ProfielScreen extends StatelessWidget {
  const ProfielScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.dialog(const LogoutDialogBox());
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
