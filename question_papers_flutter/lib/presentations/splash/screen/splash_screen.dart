import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/bottom_navbar.dart';
import 'package:question_papers_flutter/presentations/main/course/controller/course_controller.dart';
import '../controller/splash_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController controller = Get.find<SplashController>();
  final CourseController startServer = Get.find<CourseController>();
  

  // void _launchStore() async {
  //   String url = Platform.isIOS
  //       ? "https://apps.apple.com/app/idYOUR_APP_ID" // iOS App Store link
  //       : "https://play.google.com/store/apps/details?id=com.yourapp.package"; // Android Play Store link

  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(
  //       Uri.parse(url),
  //       mode: LaunchMode.externalApplication, // open in store app
  //     );
  //   } else {
  //     Get.snackbar("Error", "Could not open store");
  //   }
  // }

void _launchStore() async {
  // Android: Play Store package URL (example: WhatsApp)
  const androidUrl = "https://play.google.com/store/apps/details?id=com.whatsapp";

  // iOS: App Store URL uses the numeric app id (example: WhatsApp iOS id = 310633997)
  const iosUrl = "https://apps.apple.com/app/id310633997";

  final uri = Uri.parse(Platform.isIOS ? iosUrl : androidUrl);

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // open in store app if available
      );
    } else {
      Get.snackbar("Error", "Could not open store URL.");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to open store: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    controller.checkVersion();
    startServer.loadCourses();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Lottie.asset(
              'assets/animations/splash.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            );
          }

          final data = controller.appVersion.value;

          if (!data.updateRequired) {
            Future.delayed(const Duration(seconds: 2), () {
              Get.off(() => const BottomNavBar());
            });
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/splash.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  data.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (data.updateRequired)
                ElevatedButton(
                  onPressed: _launchStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: Text("Update Now", style: TextStyle(
                    color: isDark ? AppTheme.textColorLight : AppTheme.textColorDark,
                  ),), // remove const here
                ),
            ],
          );
        }),
      ),
    );
  }
}
