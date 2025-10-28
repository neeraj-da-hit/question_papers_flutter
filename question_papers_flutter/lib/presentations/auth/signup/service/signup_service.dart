import 'dart:io';
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
    String imagePath,
  ) async {
    // If image is selected
    if (imagePath.isNotEmpty) {
      final file = File(imagePath);

      final response = await _networkManager.uploadFileWithFields(
        endpoint: AppConstants.signup,
        imageFile: file,
        fields: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'course': course,
        },
        fieldName: 'profilePic', // 👈 must match your API parameter name
      );
      return response;
    }

    // If no image, fallback to normal post
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'course': course,
    };
    final response =
        await _networkManager.postRequest(AppConstants.signup, body);
    return response;
  }
}
