import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/controller/verify_otp_controller.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final bool isFromForgotPassword;

  const VerifyOtpScreen({
    super.key,
    required this.email,
    this.isFromForgotPassword = false,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final VerifyOtpController _otpController = Get.find<VerifyOtpController>();

  final TextEditingController _pinController = TextEditingController();
  final RxInt _secondsRemaining = 60.obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    if (_secondsRemaining.value == 0) {
      _startTimer();
      // TODO: call resend OTP API if implemented
      Get.snackbar("Info", "OTP resent to ${widget.email}");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: isDark
                        ? AppTheme.textColorDark
                        : AppTheme.textColorLight,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                "Verify OTP",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppTheme.textColorDark
                      : AppTheme.textColorLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter the 6-digit OTP sent to your email\n${widget.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // OTP Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  autoDisposeControllers: false,
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: isDark ? Colors.grey[800]! : Colors.white,
                    selectedFillColor: isDark
                        ? Colors.grey[700]!
                        : Colors.grey[100]!,
                    inactiveFillColor: isDark
                        ? Colors.grey[800]!
                        : Colors.grey[200]!,
                    activeColor: AppTheme.primaryColor,
                    selectedColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.greyText,
                  ),
                  animationDuration: const Duration(milliseconds: 200),
                  enableActiveFill: true,
                  onChanged: (_) {},
                  cursorColor: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              // Verify Button
              Obx(
                () => AppButton(
                  label: "Verify OTP",
                  isLoading: _otpController.isLoading.value,
                  onPressed: () {
                    final otp = _pinController.text.trim();
                    if (otp.isEmpty || otp.length < 6) {
                      Get.snackbar("Error", "Please enter the 6-digit OTP");
                      return;
                    }

                    if (widget.isFromForgotPassword) {
                      _otpController.verifyForgotPasswordOtp(widget.email, otp);
                    } else {
                      _otpController.verifyOtp(widget.email, otp);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Resend OTP
              Obx(() {
                final seconds = _secondsRemaining.value;
                final canResend = seconds == 0;
                return TextButton(
                  onPressed: widget.isFromForgotPassword && canResend
                      ? _resendOtp
                      : null,
                  child: Text(
                    canResend ? "Resend OTP" : "Resend OTP in ${seconds}s",
                    style: TextStyle(
                      color: canResend
                          ? AppTheme.primaryColor
                          : AppTheme.greyText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
