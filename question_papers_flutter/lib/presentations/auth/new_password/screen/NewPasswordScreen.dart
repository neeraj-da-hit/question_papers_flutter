import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/common/widgets/app_textfield.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/presentations/auth/new_password/controller/new_password_controller.dart';

class NewPasswordScreen extends StatelessWidget {
  final String email;

  NewPasswordScreen({super.key, required this.email});

  final NewPasswordController _controller = Get.put(NewPasswordController());

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: isDark
                    ? AppTheme.textColorDark
                    : AppTheme.textColorLight,
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "Set New Password",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppTheme.textColorDark
                      : AppTheme.textColorLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter your new password below for your account\n$email",
                style: const TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              /// Password Input
              AppTextField(
                label: "New Password",
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: "Confirm Password",
                controller: _confirmController,
                isPassword: true,
              ),
              const SizedBox(height: 32),

              /// Submit button
              Obx(
                () => AppButton(
                  label: "Reset Password",
                  isLoading: _controller.isLoading.value,
                  onPressed: () {
                    final password = _passwordController.text.trim();
                    final confirm = _confirmController.text.trim();

                    if (password.isEmpty || confirm.isEmpty) {
                      Get.snackbar("Error", "Please fill all fields");
                      return;
                    }

                    if (password != confirm) {
                      Get.snackbar("Error", "Passwords do not match");
                      return;
                    }

                    _controller.resetPassword(email, password);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
