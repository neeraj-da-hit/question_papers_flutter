import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/common/widgets/app_textfield.dart';
import 'package:question_papers_flutter/presentations/auth/signup/controller/sign_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignController _controller = Get.find<SignController>();

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
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(label: "Name", controller: _nameController),
            const SizedBox(height: 12),
            AppTextField(
              label: "Email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: "Phone",
              controller: _phoneController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: "Password",
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 12),
            AppTextField(label: "Course", controller: _courseController),
            const SizedBox(height: 12),
            // Image picker
            Obx(
              () => GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImage.value == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                      phone == "") {
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
          ],
        ),
      ),
    );
  }
}
