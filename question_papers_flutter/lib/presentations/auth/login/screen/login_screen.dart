import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/bottom_navbar.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import '../controller/login_controller.dart';
import 'package:question_papers_flutter/common/app_theme.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter email and password");
      return;
    }

    final success = await controller.login(email, password);
    if (success) {
      NavigationHelper.pushAndRemoveUntil(const BottomNavBar());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoggedIn.value ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: isDark ? AppTheme.textColorLight : AppTheme.textColorDark,
                        fontSize: 16,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
