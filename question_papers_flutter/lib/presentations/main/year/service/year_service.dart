import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';
import 'package:question_papers_flutter/presentations/main/year/model/semester_model.dart';

/// Handles all API operations related to semesters (years)
class YearService {
  final NetworkManager _network = NetworkManager();

  /// 📦 Fetch all semesters for a specific course
  Future<List<SemesterModel>> fetchSemesters(String courseId) async {
    final url = AppConstants.yearSem +"/"+ courseId;

    try {
      final response = await _network.getRequest(url);
      print(url);

      // Your API returns a list: [ {...}, {...} ]
      final List dataList = response["data"] ?? response;

      // Convert each JSON object into a SemesterModel
      return dataList.map((e) => SemesterModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// ➕ Add a new semester
  Future<SemesterModel?> addSemester({
    required String name,
    required String courseId,
  }) async {
    try {
      final body = {"name": name, "course": courseId};

      final response = await _network.postRequest(AppConstants.yearSem, body);

      return SemesterModel.fromJson(response["data"] ?? response);
    } catch (e) {
      rethrow;
    }
  }

  /// ❌ Delete a semester
  Future<bool> deleteSemester(String semesterId) async {
    try {
      await _network.deleteRequest("${AppConstants.yearSem}/$semesterId");
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
