import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';

class NewPasswordService {
  final NetworkManager _networkManager = NetworkManager();

  Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    final body = {"email": email, "newPassword": newPassword};
    final response = await _networkManager.postRequest(
      AppConstants.resetPassword,
      body,
    );
    return response;
  }
}
