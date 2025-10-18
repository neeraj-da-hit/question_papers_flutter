import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/auth/verify_forgot_password_otp/model/forgot_password_otp_model.dart';
import 'package:question_papers_flutter/presentations/auth/verify_forgot_password_otp/service/forgot_password_otp_service.dart';

class ForgotPasswordOtpController extends GetxController {
  final ForgotPasswordOtpService _service = ForgotPasswordOtpService();

  var response = Rxn<ForgotPasswordOtpModel>();
  var isLoading = false.obs;

  Future<void> verifyForgotPasswordOtp(String email, String otp) async {
    isLoading.value = true;
    try {
      final res = await _service.verifyForgotPasswordOtp(email, otp);

      // Parse API response
      response.value = ForgotPasswordOtpModel.fromJson(res);

      // Stop loading
      isLoading.value = false;

      // ✅ Check API message or status and notify user
      if (response.value?.message ==
          "OTP verified, you can now reset password") {
        Get.snackbar("Success", response.value!.message);
        // Navigate to reset password screen or next step
      } else {
        Get.snackbar(
          "Failed",
          response.value?.message ?? "Something went wrong",
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
}
