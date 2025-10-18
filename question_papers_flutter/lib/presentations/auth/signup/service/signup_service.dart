import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';

class SignupService {
  final NetworkManager _networkManager = NetworkManager();

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String phone,
    String course,
    String image,
  ) async {
    final body = {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "course": course,
      "image": image,
    };
    final response = await _networkManager.postRequest(
      AppConstants.signup,
      body,
    );
    return response;
  }
}
