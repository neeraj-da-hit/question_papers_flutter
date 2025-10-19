import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/auth/forgot_password/controller/forgot_password_controller.dart';
import 'package:question_papers_flutter/presentations/auth/forgot_password/service/forgot_password_service.dart';
import 'package:question_papers_flutter/presentations/auth/login/controller/login_controller.dart';
import 'package:question_papers_flutter/presentations/auth/login/service/login_service.dart';
import 'package:question_papers_flutter/presentations/auth/new_password/controller/new_password_controller.dart';
import 'package:question_papers_flutter/presentations/auth/new_password/service/new_password_service.dart';
import 'package:question_papers_flutter/presentations/auth/signup/controller/sign_controller.dart';
import 'package:question_papers_flutter/presentations/auth/signup/service/signup_service.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/controller/verify_otp_controller.dart';
import 'package:question_papers_flutter/presentations/auth/verify_otp/service/verify_otp_service.dart';
import 'package:question_papers_flutter/presentations/main/course/controller/course_controller.dart';
import 'package:question_papers_flutter/presentations/main/course/service/course_service.dart';
import 'package:question_papers_flutter/presentations/main/paper/controller/paper_controller.dart';
import 'package:question_papers_flutter/presentations/main/paper/service/paper_service.dart';
import 'package:question_papers_flutter/presentations/main/profile/controller/profile_controller.dart';
import 'package:question_papers_flutter/presentations/main/subject/controller/subject_controller.dart';
import 'package:question_papers_flutter/presentations/main/subject/service/subject_service.dart';
import 'package:question_papers_flutter/presentations/main/year/controller/year_controller.dart';
import 'package:question_papers_flutter/presentations/main/year/service/year_service.dart';
import 'package:question_papers_flutter/presentations/splash/controller/splash_controller.dart';
import 'package:question_papers_flutter/presentations/splash/service/splash_service.dart';

/// Initialize all dependencies for the app
Future<void> initDependencies() async {
  // Services
  Get.put<CourseService>(CourseService(), permanent: true);
  Get.put<YearService>(YearService(), permanent: true);
  Get.put<SubjectService>(SubjectService(), permanent: true);
  Get.put<PaperService>(PaperService(), permanent: true);
  Get.put<SplashService>(SplashService(), permanent: true);
  Get.put<LoginService>(LoginService(), permanent: true);
  Get.put<SignupService>(SignupService(), permanent: true);
  Get.put<VerifyOtpService>(VerifyOtpService(), permanent: true);
  Get.put<ForgotPasswordService>(ForgotPasswordService(), permanent: true);
  Get.put<NewPasswordService>(NewPasswordService(), permanent: true);

  // Controllers
  Get.put<CourseController>(CourseController(), permanent: true);
  Get.put<YearController>(YearController(), permanent: true);
  Get.put<SubjectController>(SubjectController(), permanent: true);
  Get.put<PaperController>(PaperController(), permanent: true);
  Get.put<SplashController>(SplashController(), permanent: true);
  Get.put<LoginController>(LoginController(), permanent: true);
  Get.put<SignController>(SignController(), permanent: true);
  Get.put<VerifyOtpController>(VerifyOtpController(), permanent: true);
  Get.put<ForgotPasswordController>(
    ForgotPasswordController(),
    permanent: true,
  );
  Get.put<ProfileController>(ProfileController(), permanent: true);
  Get.put<NewPasswordController>(NewPasswordController(), permanent: true);
  // Get.put<ForgotPasswordOtpController>(
  //   ForgotPasswordOtpController(),
  //   permanent: true,
  // );
}
