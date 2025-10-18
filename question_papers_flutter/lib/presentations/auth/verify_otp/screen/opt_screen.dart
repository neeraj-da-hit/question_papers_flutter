import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/common/widgets/app_textfield.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/controller/verify_otp_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String email;

  VerifyOtpScreen({super.key, required this.email});

  final VerifyOtpController _controller = Get.find<VerifyOtpController>();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Text(
              "Enter the 6-digit OTP sent to",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              email,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppTextField(
              label: "OTP",
              controller: _otpController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Obx(
              () => AppButton(
                label: "Verify OTP",
                isLoading: _controller.isLoading.value,
                onPressed: () {
                  final otp = _otpController.text.trim();
                  if (otp.isEmpty) {
                    Get.snackbar("Error", "Please enter the OTP");
                    return;
                  }
                  _controller.verifyOtp(email, otp);
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Implement resend OTP API call (if available)
                Get.snackbar("Info", "OTP resent to $email");
              },
              child: const Text("Resend OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
