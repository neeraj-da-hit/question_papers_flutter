import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/widgets/app_button.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/auth/new_password/screen/NewPasswordScreen.dart';
import 'package:question_papers_flutter/presentations/main/profile/controller/profile_controller.dart';
import 'package:question_papers_flutter/presentations/main/profile/widgets/logout_dialog_box.dart';
import 'package:question_papers_flutter/presentations/main/profile/widgets/profile_info_tile.dart';
import 'package:question_papers_flutter/presentations/main/profile/widgets/section_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔥 Auto-fetch when the screen appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = profileController.loginController.user.value?.id ?? '';
      if (id.isNotEmpty) {
        profileController.fetchProfileData(id);
      }
    });
  }

  // 🔄 Pull-to-refresh handler
  Future<void> _onRefresh() async {
    final id = profileController.loginController.user.value?.id ?? '';
    if (id.isNotEmpty) {
      await profileController.fetchProfileData(id);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // ✏️ Edit Button
          TextButton(
            onPressed: () {
              // TODO: Navigate to edit profile screen when implemented
              Get.snackbar("Edit", "Edit profile feature coming soon!");
            },
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
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = profileController.data.value?.user;
        if (profile == null) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 300),
                Center(child: Text("No profile data found")),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: theme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // 👤 Avatar + Name + Email
                Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: isDark
                          ? Colors.grey[800]
                          : Colors.grey[300],
                      backgroundImage: profile.profilePic.isNotEmpty
                          ? NetworkImage(profile.profilePic)
                          : const AssetImage('assets/images/hinata.jpeg')
                                as ImageProvider,
                    ),

                    const SizedBox(height: 12),
                    Text(
                      profile.name,
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
                      profile.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // 📄 Personal Info
                _buildCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: "Personal Information",
                        showBackground: true,
                      ),
                      ProfileInfoTile(title: "Name", value: profile.name),
                      ProfileInfoTile(title: "Email", value: profile.email),
                      ProfileInfoTile(
                        title: "Phone",
                        value: profile.phone.toString(),
                        showDivider: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🎓 Course Info
                _buildCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: "Course Details",
                        showBackground: true,
                      ),
                      ProfileInfoTile(title: "Course", value: profile.course),
                      ProfileInfoTile(
                        title: "Verified",
                        value: profile.isVerified ? "Yes" : "No",
                        showDivider: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔒 Security + Logout
                _buildCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: "Security",
                        showBackground: true,
                      ),
                      ListTile(
                        dense: true,
                        title: const Text("Change Password"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        onTap: () {
                          NavigationHelper.push(
                            NewPasswordScreen(email: profile.email),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // 🔘 Logout Button (with dialog)
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
      }),
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
