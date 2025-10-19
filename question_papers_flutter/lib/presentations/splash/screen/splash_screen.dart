import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/bottom_navbar.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/auth/login/controller/login_controller.dart';
import 'package:question_papers_flutter/presentations/auth/login/screen/login_screen.dart';
import '../controller/splash_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LoginController loginController = Get.find<LoginController>();
  final SplashController splashController = Get.find<SplashController>();

  final List<String> loadingTexts = [
    "Checking for updates…",
    "Waking up the server, please wait…",
    "Almost ready to start…",
  ];

  int _currentTextIndex = 0;
  bool _fadeIn = true;

  @override
  void initState() {
    super.initState();
    splashController.checkVersion();

    // Animation text loop
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!splashController.isLoading.value) {
        timer.cancel();
      } else {
        setState(() => _fadeIn = false);
        Future.delayed(const Duration(milliseconds: 400), () {
          setState(() {
            _currentTextIndex = (_currentTextIndex + 1) % loadingTexts.length;
            _fadeIn = true;
          });
        });
      }
    });

    // Listen for version check completion
    ever(splashController.isLoading, (loading) async {
      if (loading == false) {
        final data = splashController.appVersion.value;

        if (data.updateRequired) {
          // Stay on screen, user can tap Update button
          return;
        } else {
          await _checkAutoLogin();
        }
      }
    });
  }

  Future<void> _checkAutoLogin() async {
    await loginController.loadFromPrefs();

    // Give a small delay for smooth UX
    await Future.delayed(const Duration(milliseconds: 600));

    if (loginController.isLoggedIn.value) {
      NavigationHelper.pushAndRemoveUntil(const BottomNavBar());
    } else {
      NavigationHelper.pushAndRemoveUntil(LoginScreen());
    }
  }

  void _launchStore() async {
    const androidUrl =
        "https://play.google.com/store/apps/details?id=com.whatsapp";
    const iosUrl = "https://apps.apple.com/app/id310633997";
    final uri = Uri.parse(Platform.isIOS ? iosUrl : androidUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not open store URL.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to open store: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: Center(
        child: Obx(() {
          if (splashController.isLoading.value) {
            // Show loading animation
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/splash.json',
                  frameRate: FrameRate.max,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                AnimatedOpacity(
                  opacity: _fadeIn ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    loadingTexts[_currentTextIndex],
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppTheme.textColorDark
                          : AppTheme.textColorLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }

          final data = splashController.appVersion.value;

          // After version check completed
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/uptodate.json',
                frameRate: FrameRate.max,
                repeat: true,
                width: 220,
                height: 220,
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
                    color: isDark
                        ? AppTheme.textColorDark
                        : AppTheme.textColorLight,
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
                  child: const Text(
                    "Update Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
