import 'package:get/get.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/auth/login/screen/login_screen.dart';
import 'package:question_papers_flutter/presentations/auth/new_password/model/new_password_model.dart';
import 'package:question_papers_flutter/presentations/auth/new_password/service/new_password_service.dart';

class NewPasswordController extends GetxController {
  final NewPasswordService _newPasswordService = NewPasswordService();

  var resetResponse = Rxn<NewPasswordModel>();
  var isLoading = false.obs;

  Future<void> resetPassword(String email, String newPassword) async {
    isLoading.value = true;
    try {
      final res = await _newPasswordService.resetPassword(email, newPassword);

      // Parse API response
      resetResponse.value = NewPasswordModel.fromJson(res);

      // Stop loading
      isLoading.value = false;

      // ✅ Check API message or status and notify user
      if (resetResponse.value?.message == "Password reset successfully") {
        Get.snackbar("Success", resetResponse.value!.message);
        NavigationHelper.pushAndRemoveUntil(LoginScreen());
      } else {
        Get.snackbar(
          "Failed",
          resetResponse.value?.message ?? "Something went wrong",
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
}
