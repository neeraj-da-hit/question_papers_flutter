import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/bottom_navbar.dart';
import '../controller/splash_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(SplashController());

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
    controller.checkVersion();

    // Text animation loop (change every 3.5s)
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!controller.isLoading.value) {
        timer.cancel();
      } else {
        setState(() {
          _fadeIn = false;
        });
        Future.delayed(const Duration(milliseconds: 400), () {
          setState(() {
            _currentTextIndex =
                (_currentTextIndex + 1) % loadingTexts.length;
            _fadeIn = true;
          });
        });
      }
    });
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
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
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

                // ✨ Animated fading text
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
                'assets/animations/uptodate.json',
                frameRate: FrameRate.max,
                repeat: false,
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
