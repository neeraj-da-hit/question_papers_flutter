import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/auth/new_password/screen/NewPasswordScreen.dart';
// import 'package:question_papers_flutter/presentations/main/profile/controller/profile_controller.dart';
import 'package:question_papers_flutter/presentations/main/profile/widgets/logout_dialog_box.dart';
import 'package:question_papers_flutter/presentations/main/profile/widgets/profile_info_tile.dart';
import 'package:question_papers_flutter/presentations/main/profile/widgets/section_header.dart';
import 'package:question_papers_flutter/common/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<ProfileController>();

    final mockUser = {
      "name": "Sophia Carter",
      "email": "sophia.carter@email.com",
      "role": "Student",
      "studentId": "1234567890",
      "major": "Computer Science",
      "institution": "University of Technology",
    };

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Edit",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // 👤 Avatar + Name + Email
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                  backgroundImage: const AssetImage(
                    'assets/images/hinata.jpeg',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  mockUser['name']!,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppTheme.textColorDark
                        : AppTheme.textColorLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mockUser['email']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 📄 Personal Info Card
            _buildCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: "Personal Information",
                    showBackground: true,
                  ),
                  ProfileInfoTile(title: "Name", value: mockUser['name']!),
                  ProfileInfoTile(
                    title: "Email",
                    value: mockUser['email']!,
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📚 Academic Info Card
            _buildCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: "Academic Details",
                    showBackground: true,
                  ),
                  ProfileInfoTile(title: "Role", value: mockUser['role']!),
                  ProfileInfoTile(
                    title: "Student ID",
                    value: mockUser['studentId']!,
                  ),
                  ProfileInfoTile(title: "Major", value: mockUser['major']!),
                  ProfileInfoTile(
                    title: "Institution",
                    value: mockUser['institution']!,
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔒 Security Card
            _buildCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: "Security", showBackground: true),
                  ListTile(
                    dense: true,
                    title: const Text(
                      "Change Password",
                      style: TextStyle(fontSize: 15),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    onTap: () {
                      NavigationHelper.push(
                        NewPasswordScreen(email: mockUser['email']!),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AppButton(
                      label: "Logout",
                      onPressed: () {
                        Get.dialog(const LogoutDialogBox());
                      },
                      isDisabled: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius + 4),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.5)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
