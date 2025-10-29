import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/common/widgets/app_textfield.dart';

import 'package:question_papers_flutter/presentations/main/profile/controller/profile_controller.dart';
import 'package:question_papers_flutter/presentations/main/profile/model/user_profile_response.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final UserProfile profile;
  const ProfileUpdateScreen({super.key, required this.profile});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController courseController;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    phoneController = TextEditingController(
      text: widget.profile.phone?.toString() ?? '', // Handle nullable phone
    );
    courseController = TextEditingController(
      text: widget.profile.course ?? '',
    ); // Handle nullable course
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  Future<void> onSave() async {
    if (!_formKey.currentState!.validate()) return;

    await profileController.updateProfile(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      course: courseController.text.trim(),
      profilePic: imageFile,
    );

    if (!profileController.isUpdating.value) {
      Get.back();
      // optional: refresh profile on return
      final id = profileController.loginController.user.value?.id ?? '';
      if (id.isNotEmpty) profileController.fetchProfileData(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 👤 Profile Picture
                GestureDetector(
                  onTap: pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: isDark
                            ? Colors.grey[800]
                            : Colors.grey[300],
                        backgroundImage: imageFile != null
                            ? FileImage(imageFile!) as ImageProvider
                            : (widget.profile.profilePic != null &&
                                  widget.profile.profilePic!.isNotEmpty)
                            ? NetworkImage(widget.profile.profilePic!)
                                  as ImageProvider
                            : const AssetImage('assets/images/hinata.jpeg'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                AppTextField(label: "Fullname", controller: nameController),

                const SizedBox(height: 16),

                AppTextField(
                  label: "Phone No",
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                AppTextField(label: "Course", controller: courseController),
                const SizedBox(height: 32),

                AppButton(
                  label: profileController.isUpdating.value
                      ? "Saving..."
                      : "Save Changes",
                  // pass a non-null callback and rely on isDisabled to prevent presses
                  onPressed: () => onSave(),
                  isDisabled: profileController.isUpdating.value,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
