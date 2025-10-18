import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';

class VerifyOtpService {
  final NetworkManager _networkManager = NetworkManager();

  Future<Map<String, dynamic>> vefiryOtp(String email, String otp) async {
    final body = {"email": email, "otp": otp};
    final response = await _networkManager.postRequest(
      AppConstants.veriyOtp,
      body,
    );
    return response;
  }
}
