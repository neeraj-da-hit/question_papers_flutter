import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/widgets/app_textfield.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/presentations/auth/forgot_password/controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController _controller = Get.put(
    ForgotPasswordController(),
  );

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: isDark
            ? AppTheme.backgroundDark
            : AppTheme.backgroundLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              "Forgot your password?",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppTheme.textColorDark
                    : AppTheme.textColorLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter your registered email address to receive an OTP for password reset.",
              style: TextStyle(color: AppTheme.greyText, fontSize: 15),
            ),
            const SizedBox(height: 32),

            /// 📧 Email Input
            AppTextField(
              label: "Email Address",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 24),

            /// 🔘 Submit Button
            Obx(
              () => AppButton(
                label: "Send OTP",
                isLoading: _controller.isLoading.value,
                onPressed: () {
                  final email = _emailController.text.trim();

                  if (email.isEmpty || !email.contains("@")) {
                    Get.snackbar("Error", "Please enter a valid email");
                    return;
                  }

                  _controller.sendForgotPasswordOtp(email);
                },
              ),
            ),

            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
