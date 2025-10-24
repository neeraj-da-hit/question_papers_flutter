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
  static const String paper = "api/paper";
  static const String coursesEndpoint = "courses";
  static const String uploadPdfEndpoint = "upload/pdf";
  static const String resetPassword = "api/auth/reset-password";

  //auth
  static const String login = "api/auth/login";
  static const String signup = "api/auth/register";
  static const String veriyOtp = "api/auth/verify-otp";
  static const String forgotPassword = "api/auth/forgot-password";
  static const String verifyForgotOtp = "api/auth/verify-reset-otp";
  static const String userProfile = "api/auth/profile";

  // =======================
  // App Strings
  // =======================
  static const String appName = "Question Papers";
  static const String welcomeMessage = "Welcome to Your App!";
  static const String errorMessage = "Something went wrong, please try again.";

  // =======================
  // Shared Preferences Keys
  // =======================
  static const String prefUserToken = "PREF_USER_TOKEN";
  static const String prefUserName = "PREF_USER_NAME";
  static const String prefUserEmail = "PREF_USER_EMAIL";
  static const String prefUserId = "PREF_USER_ID";

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
