import 'package:get/get.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/auth/login/controller/login_controller.dart';
import 'package:question_papers_flutter/presentations/auth/login/screen/login_screen.dart';
import 'package:question_papers_flutter/presentations/main/profile/model/user_profile_response.dart';
import 'package:question_papers_flutter/presentations/main/profile/service/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  final LoginController loginController = Get.find<LoginController>();

  var data = Rxn<UserProfileResponse>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch profile automatically on init using user id
    final id = loginController.user.value?.id ?? '';
    if (id.isNotEmpty) {
      fetchProfileData(id);
    }
  }

  Future<void> fetchProfileData(String id) async {
    if (id.isEmpty) return;
    isLoading.value = true;
    try {
      final res = await _profileService.fetchProfileData(id);
      data.value = UserProfileResponse.fromJson(res);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch profile data: $e");
      logout();
      NavigationHelper.pushAndRemoveUntil(LoginScreen());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await loginController.logout();
    Get.offAll(() => LoginScreen());
  }
}
