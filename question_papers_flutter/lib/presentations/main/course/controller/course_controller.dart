import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/main/course/model/course_model.dart';
import 'package:question_papers_flutter/presentations/main/course/service/course_service.dart';

class CourseController extends GetxController {
  final CourseService _service = CourseService();

  var courses = <CourseModel>[].obs;
  var isLoading = false.obs;
  var groupedCourses = <String, List<CourseModel>>{}.obs;

  Future<void> loadCourses() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchCourses();
      courses.assignAll(data);
      groupCoursesByType();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Group dynamically based on course name
  void groupCoursesByType() {
    Map<String, List<CourseModel>> grouped = {
      "School": [],
      "Graduation": [],
      "Post Graduation": [],
      "Diploma": [],
      "Other": [],
    };

    for (var course in courses) {
      final name = course.name.toLowerCase();

      if (name.contains("class")) {
        grouped["School"]!.add(course);
      } else if (name.startsWith("b")) {
        grouped["Graduation"]!.add(course);
      } else if (name.startsWith("m")) {
        grouped["Post Graduation"]!.add(course);
      } else if (name.contains("poly") ||
          name.contains("polo") ||
          name.contains("diploma")) {
        grouped["Diploma"]!.add(course);
      } else {
        grouped["Other"]!.add(course);
      }
    }

    // ✅ Sort alphabetically inside each group
    for (var key in grouped.keys) {
      grouped[key]!.sort((a, b) => a.name.compareTo(b.name));
    }

    groupedCourses.value = grouped;
  }
}
