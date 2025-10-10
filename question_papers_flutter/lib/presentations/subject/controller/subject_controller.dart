import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/subject/model/subject_model.dart';
import 'package:question_papers_flutter/presentations/subject/service/subject_service.dart';

class SubjectController extends GetxController {
  final SubjectService _service = SubjectService();

  var subjects = <SubjectModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> laodSubjects(String subjecId) async {
    try {
      isLoading.value = true;
      final data = await _service.fetchSubjects(subjecId);
      subjects.assignAll(data);
    } catch (e) {
      try {
        Get.snackbar("Error", e.toString());
      } catch (_) {
        debugPrint("Snackbar failed: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
