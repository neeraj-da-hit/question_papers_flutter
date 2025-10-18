import 'package:get/get.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/auth/login/screen/login_screen.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/model/vefiry_model.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/service/verify_otp_service.dart';

class VerifyOtpController extends GetxController {
  final VerifyOtpService _service = VerifyOtpService();

  var otpResponse = Rxn<VefiryModel>();
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
}
