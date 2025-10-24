import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';

class ProfileService {
  final NetworkManager _networkManager = NetworkManager();

  Future<Map<String, dynamic>> fetchProfileData(String id) async {
    final response = await _networkManager.getRequest(
      AppConstants.userProfile + '/$id',
    );
    return response;
  }
}
