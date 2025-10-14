import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/main/year/model/semester_model.dart';
import 'package:question_papers_flutter/presentations/main/year/service/year_service.dart';

class YearController extends GetxController {
  final YearService _service = YearService();

  // Observable list of semesters
  var semesters = <SemesterModel>[].obs;
  var isLoading = false.obs;

  /// 📦 Load semesters for a given course
  Future<void> loadSemesters(String courseId) async {
    try {
      isLoading.value = true;
      final data = await _service.fetchSemesters(courseId);
      semesters.assignAll(data);
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
