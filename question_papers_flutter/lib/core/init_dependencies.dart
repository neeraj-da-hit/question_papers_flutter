import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/course/controller/course_controller.dart';
import 'package:question_papers_flutter/presentations/course/service/course_service.dart';
import 'package:question_papers_flutter/presentations/paper/controller/paper_controller.dart';
import 'package:question_papers_flutter/presentations/paper/service/paper_service.dart';
import 'package:question_papers_flutter/presentations/subject/controller/subject_controller.dart';
import 'package:question_papers_flutter/presentations/subject/service/subject_service.dart';
import 'package:question_papers_flutter/presentations/year/controller/year_controller.dart';
import 'package:question_papers_flutter/presentations/year/service/year_service.dart';

/// Initialize all dependencies for the app
Future<void> initDependencies() async {
  // Services
  Get.put<CourseService>(CourseService(), permanent: true);
  Get.put<YearService>(YearService(), permanent: true);
  Get.put<SubjectService>(SubjectService(), permanent: true);
  Get.put<PaperService>(PaperService(), permanent: true);

  // Controllers
  Get.put<CourseController>(CourseController(), permanent: true);
  Get.put<YearController>(YearController(), permanent: true);
  Get.put<SubjectController>(SubjectController(), permanent: true);
  Get.put<PaperController>(PaperController(), permanent: true);
}
