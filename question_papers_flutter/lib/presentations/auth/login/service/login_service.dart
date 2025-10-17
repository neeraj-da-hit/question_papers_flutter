import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';

class LoginService {
  final NetworkManager _networkManager = NetworkManager();

  Future <Map<String, dynamic>> login(String email, String password) async {
    final body = {
      "email": email,
      "password": password,
    };
    final response = await _networkManager.postRequest(AppConstants.login, body);
    return response;
  }
}