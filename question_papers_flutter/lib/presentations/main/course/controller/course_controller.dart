import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/main/course/model/course_model.dart';
import 'package:question_papers_flutter/presentations/main/course/service/course_service.dart';

class CourseController extends GetxController {
  final CourseService _service = CourseService();
  var courses = <CourseModel>[].obs;
  var isLoading = false.obs;

  Future<void> loadCourses() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchCourses();
      courses.assignAll(data);
    } catch (e) {
      try {
        Get.snackbar("Error", e.toString());
      } catch (_) {
        debugPrint("Snackbar failed: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
