import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/course/controller/course_controller.dart';
import 'package:question_papers_flutter/presentations/course/service/course_service.dart';

/// Initialize all dependencies for the app
Future<void> initDependencies() async {
  // Services
  Get.put<CourseService>(CourseService(), permanent: true);

  // Controllers
  Get.put<CourseController>(CourseController(), permanent: true);
}
