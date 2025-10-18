import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/bottom_navbar.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/common/widgets/app_textfield.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/auth/signup/screen/signup_screen.dart';
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

    controller.isLoggedIn.value = true;

    final success = await controller.login(email, password);

    controller.isLoggedIn.value = false;

    if (success) {
      NavigationHelper.pushAndRemoveUntil(const BottomNavBar());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppTheme.textColorDark
                      : AppTheme.textColorLight,
                ),
              ),
              const SizedBox(height: 30),

              // ✉️ Email Field
              AppTextField(
                label: "Email",
                controller: emailController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // 🔒 Password Field
              AppTextField(
                label: "Password",
                controller: passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 30),

              // 🔘 Login Button
              Obx(
                () => AppButton(
                  label: "Login",
                  isLoading: controller.isLoggedIn.value,
                  onPressed: controller.isLoggedIn.value ? () {} : _login,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textColorDark
                          : AppTheme.textColorLight,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // navigation to sign up screen
                      NavigationHelper.push(SignupScreen());
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
