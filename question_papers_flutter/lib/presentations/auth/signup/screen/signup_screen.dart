import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/common/widgets/app_textfield.dart';
import 'package:question_papers_flutter/presentations/auth/signup/controller/sign_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignController _controller = Get.put(SignController());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  final Rx<File?> _selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back Button
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     IconButton(
              //       onPressed: () => Get.back(),
              //       icon: const Icon(Icons.close),
              //       color: isDark
              //           ? AppTheme.textColorDark
              //           : AppTheme.textColorLight,
              //     ),
              //   ],
              // ),
              const SizedBox(height: 10),

              // 🧭 Header Section
              Text(
                "Create Account",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppTheme.textColorDark
                      : AppTheme.textColorLight,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Join us today! Please fill in your details below to get started.",
                style: TextStyle(color: AppTheme.greyText, fontSize: 15),
              ),
              const SizedBox(height: 32),

              // 👤 Fields
              AppTextField(label: "Full Name", controller: _nameController),
              const SizedBox(height: 12),
              AppTextField(
                label: "Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: "Phone Number",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: "Password",
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 12),
              AppTextField(label: "Course", controller: _courseController),

              const SizedBox(height: 24),

              // 🖼️ Image Picker
              Center(
                child: Column(
                  children: [
                    Obx(
                      () => GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.backgroundDark.withOpacity(0.3)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                              AppTheme.defaultRadius,
                            ),
                            border: Border.all(
                              color: AppTheme.greyText.withOpacity(0.3),
                            ),
                          ),
                          child: _selectedImage.value == null
                              ? const Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppTheme.greyText,
                                  size: 40,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.defaultRadius,
                                  ),
                                  child: Image.file(
                                    _selectedImage.value!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Tap to upload your profile picture",
                      style: TextStyle(fontSize: 14, color: AppTheme.greyText),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔘 Sign Up Button
              Obx(
                () => AppButton(
                  label: "Sign Up",
                  isLoading: _controller.isLoading.value,
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final email = _emailController.text.trim();
                    final phone = _phoneController.text.trim();
                    final password = _passwordController.text.trim();
                    final course = _courseController.text.trim();
                    final imagePath = _selectedImage.value?.path ?? '';

                    if (name.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty ||
                        course.isEmpty ||
                        phone.isEmpty) {
                      Get.snackbar("Error", "Please fill all fields");
                      return;
                    }

                    _controller.signup(
                      name,
                      email,
                      password,
                      phone,
                      course,
                      imagePath,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 🔁 Already have account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppTheme.greyText),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
