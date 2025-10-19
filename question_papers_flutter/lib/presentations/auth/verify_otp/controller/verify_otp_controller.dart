import 'package:get/get.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/auth/login/screen/login_screen.dart';
import 'package:question_papers_flutter/presentations/auth/new_password/screen/NewPasswordScreen.dart';
import 'package:question_papers_flutter/presentations/auth/verify_forgot_password_otp/model/forgot_password_otp_model.dart';
import 'package:question_papers_flutter/presentations/auth/verify_forgot_password_otp/service/forgot_password_otp_service.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/model/vefiry_model.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/service/verify_otp_service.dart';

class VerifyOtpController extends GetxController {
  final VerifyOtpService _service = VerifyOtpService();
  final ForgotPasswordOtpService _service2 = ForgotPasswordOtpService();

  var otpResponse = Rxn<VefiryModel>();
  var response = Rxn<ForgotPasswordOtpModel>();
  var isLoading = false.obs;

  Future<void> verifyOtp(String email, String otp) async {
    isLoading.value = true;
    try {
      final res = await _service.vefiryOtp(email, otp);
      otpResponse.value = VefiryModel.fromJson(res);
      isLoading.value = false;
      if (otpResponse.value?.message ==
          "Email verified and account created ✅") {
        Get.snackbar("Success", otpResponse.value?.message ?? "Verified");
        NavigationHelper.pushAndRemoveUntil(LoginScreen());
      } else {
        Get.snackbar("", otpResponse.value?.message ?? "Something went wrong");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("OTP Verification Failed", e.toString());
    }
  }

  Future<void> verifyForgotPasswordOtp(String email, String otp) async {
    isLoading.value = true;
    try {
      final res = await _service2.verifyForgotPasswordOtp(email, otp);

      // Parse API response
      response.value = ForgotPasswordOtpModel.fromJson(res);

      // Stop loading
      isLoading.value = false;

      // ✅ Check API message or status and notify user
      if (response.value?.message ==
          "OTP verified, you can now reset password") {
        Get.snackbar("Success", response.value!.message);
        // Navigate to reset password screen or next step
        NavigationHelper.push(NewPasswordScreen(email: email));
      } else {
        Get.snackbar(
          "Failed",
          response.value?.message ?? "Something went wrong",
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
      print(e.toString());
    }
  }
}
