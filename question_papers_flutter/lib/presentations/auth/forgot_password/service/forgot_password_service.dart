import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';

class ForgotPasswordService {
  final NetworkManager _network = NetworkManager();

  Future<Map<String, dynamic>> sendForgotPasswordOtp(String email) async {
    final body = {"email": email};
    final response = await _network.postRequest(
      AppConstants.forgotPassword,
      body,
    );
    return response;
  }
}
