import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';
import 'package:question_papers_flutter/presentations/course/model/course_model.dart';

/// Handles all API operations related to courses
class CourseService {
  final NetworkManager _network = NetworkManager();

  /// Fetch all courses
  Future<List<CourseModel>> fetchCourses() async {
    final url = AppConstants.allCourse;
    try {
      final response = await _network.getRequest(url);
      print(url);

      // Since your response is a list: [ {...}, {...} ]
      final List dataList = response["data"] ?? response;

      return dataList.map((e) => CourseModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Example: add new course
  Future<CourseModel?> addCourse(String name) async {
    try {
      final body = {"name": name};
      final response = await _network.postRequest(
        AppConstants.coursesEndpoint,
        body,
      );
      return CourseModel.fromJson(response["data"] ?? response);
    } catch (e) {
      rethrow;
    }
  }

  /// Example: delete a course
  Future<bool> deleteCourse(String courseId) async {
    try {
      await _network.deleteRequest("${AppConstants.coursesEndpoint}/$courseId");
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
