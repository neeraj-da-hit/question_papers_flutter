import 'dart:io';
import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';

class ProfileService {
  final NetworkManager _networkManager = NetworkManager();

  /// 🔹 Fetch user profile by ID
  Future<Map<String, dynamic>> fetchProfileData(String id) async {
    final response = await _networkManager.getRequest(
      AppConstants.userProfile + '/$id',
    );
    return response;
  }

  /// 🔹 Update user profile (multipart PUT)
  ///
  /// Fields accepted by API:
  /// - name
  /// - email
  /// - phone
  /// - course
  /// - [profilePic] (optional image file)
  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String name,
    required String phone,
    required String course,
    File? profilePic,
  }) async {
    final fields = {'name': name, 'phone': phone, 'course': course};

    // Uses our new PUT multipart method in NetworkManager
    final response = await _networkManager.putMultipartRequest(
      endpoint: '${AppConstants.userProfile}/$userId',
      fields: fields,
      imageFile: profilePic, // optional
      imageFieldName: 'profilePic',
    );

    return response;
  }
}
