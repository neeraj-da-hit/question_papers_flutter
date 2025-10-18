import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';

class ForgotPasswordOtpService {
  final NetworkManager _networkManager = NetworkManager();

  Future<Map<String, dynamic>> verifyForgotPasswordOtp(
    String email,
    String otp,
  ) async {
    final body = {"email": email, "otp": otp};
    final response = await _networkManager.postRequest(
      AppConstants.verifyForgotOtp,
      body,
    );
    return response;
  }
}
