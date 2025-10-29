import 'dart:convert';
import 'package:get/get.dart';
import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/presentations/auth/login/service/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class LoginController extends GetxController {
  final LoginService _service = LoginService();

  var user = Rxn<UserModel>();
  var token = ''.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFromPrefs();
  }

  void saveToPrefs(UserModel u, String t) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefUserToken, t);
    await prefs.setString(AppConstants.prefUserEmail, u.email);
    await prefs.setString(AppConstants.prefUserId, u.id);
    await prefs.setString(AppConstants.prefUserName, jsonEncode(u.toJson()));
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(AppConstants.prefUserToken);
    final u = prefs.getString(AppConstants.prefUserName);

    if (t != null && u != null) {
      token.value = t;
      user.value = UserModel.fromJson(jsonDecode(u));
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false; // default false
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final res = await _service.login(email, password);
      final userData = UserModel.fromJson(res['user']);
      final userToken = res['token'];

      user.value = userData;
      token.value = userToken;
      isLoggedIn.value = true;

      saveToPrefs(userData, userToken);
      return true;
    } catch (e) {
      // ✅ Extract only the message part
      final errorMessage = e.toString().replaceFirst('', '');
      Get.snackbar("Login Failed", errorMessage);
      return false;
    } finally {}
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefUserToken);
    await prefs.remove(AppConstants.prefUserName);
    user.value = null;
    token.value = '';
    isLoggedIn.value = false;
  }
}
