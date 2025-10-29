import 'dart:io';
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
  var isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    final id = loginController.user.value?.id ?? '';
    if (id.isNotEmpty) {
      fetchProfileData(id);
    }
  }

  /// 🧩 Fetch Profile Data
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

  /// 🧩 Update Profile Data
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String course,
    File? profilePic,
  }) async {
    final id = loginController.user.value?.id ?? '';
    if (id.isEmpty) {
      Get.snackbar("Error", "User ID not found. Please log in again.");
      return;
    }

    try {
      isUpdating.value = true;

      final res = await _profileService.updateProfile(
        userId: id,
        name: name,
        phone: phone,
        course: course,
        profilePic: profilePic,
      );

      // Update local data model with new response
      if (res['user'] != null) {
        data.value = UserProfileResponse.fromJson(res);
        Get.back(); // Close update screen on success
        Get.snackbar("Success", "Profile updated successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  /// 🚪 Logout and redirect to login
  Future<void> logout() async {
    await loginController.logout();
    Get.offAll(() => LoginScreen());
  }
}
