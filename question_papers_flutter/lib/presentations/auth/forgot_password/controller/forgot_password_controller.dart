import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/auth/forgot_password/model/forgot_psd_model.dart';
import 'package:question_papers_flutter/presentations/auth/forgot_password/service/forgot_password_service.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/screen/opt_screen.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordService _service = ForgotPasswordService();

  var forgotResponse = Rxn<ForgotPsdModel>();
  var isLoading = false.obs;

  Future<void> sendForgotPasswordOtp(String email) async {
    isLoading.value = true;
    try {
      final res = await _service.sendForgotPasswordOtp(email);

      // Parse API response
      forgotResponse.value = ForgotPsdModel.fromJson(res);

      // Stop loading
      isLoading.value = false;

      // ✅ Check API message or status and notify user
      if (forgotResponse.value?.message ==
          "OTP sent to email for password reset") {
        Get.snackbar("Success", forgotResponse.value!.message);
        Get.to(() => VerifyOtpScreen(email: email));
      } else {
        Get.snackbar(
          "Failed",
          forgotResponse.value?.message ?? "Something went wrong",
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
}
