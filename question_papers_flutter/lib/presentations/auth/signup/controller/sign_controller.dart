import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/auth/signup/model/register_model.dart';
import 'package:question_papers_flutter/presentations/auth/signup/service/signup_service.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/screen/opt_screen.dart';

class SignController extends GetxController {
  final SignupService _service = SignupService();

  var responseMessage = Rxn<RegisterModel>();
  var isLoading = false.obs;

  Future<void> signup(
    String name,
    String email,
    String password,
    String phone,
    String course,
    String image,
  ) async {
    isLoading.value = true;
    try {
      final res = await _service.signup(
        name,
        email,
        password,
        phone,
        course,
        image,
      );

      // Parse API response
      responseMessage.value = RegisterModel.fromJson(res);

      // Stop loading
      isLoading.value = false;

      // ✅ Check API message or status and navigate
      if (responseMessage.value?.message == "OTP sent to email") {
        Get.snackbar("Success", responseMessage.value!.message);
        Get.to(() => VerifyOtpScreen(email: email));
      } else {
        Get.snackbar(
          "Signup Failed",
          responseMessage.value?.message ?? "Something went wrong",
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Signup Failed", e.toString());
    }
  }
}
