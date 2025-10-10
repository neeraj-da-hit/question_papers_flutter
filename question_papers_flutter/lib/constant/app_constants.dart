import 'package:flutter/material.dart';

/// App-wide constants organized by category
class AppConstants {
  // =======================
  // API Endpoints & Config
  // =======================
  static const String baseApiUrl = "https://exam-buddy-yaya.onrender.com";

  // Example endpoints
  static const String allCourse = "api/course";
  static const String yearSem = "api/semester";
  static const String subject = "api/subject";
  static const String coursesEndpoint = "courses";
  static const String uploadPdfEndpoint = "upload/pdf";

  // =======================
  // App Strings
  // =======================
  static const String appName = "Your App Name";
  static const String welcomeMessage = "Welcome to Your App!";
  static const String errorMessage = "Something went wrong, please try again.";

  // =======================
  // Shared Preferences Keys
  // =======================
  static const String prefUserToken = "PREF_USER_TOKEN";
  static const String prefUserName = "PREF_USER_NAME";

  // =======================
  // Colors
  // =======================
  static const Color primaryColor = Color(0xFF0A73FF);
  static const Color secondaryColor = Color(0xFF00C853);
  static const Color errorColor = Color(0xFFD32F2F);

  // =======================
  // Other Constants
  // =======================
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
}
