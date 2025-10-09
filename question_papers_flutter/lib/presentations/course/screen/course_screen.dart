import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/course/controller/course_controller.dart';
import 'package:question_papers_flutter/presentations/course/widgets/course_tile.dart';
import 'package:question_papers_flutter/presentations/year/screen/year_screen.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseController controller = Get.find<CourseController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Load courses when the screen first opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCourses();
    });

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Courses",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.courses.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadCourses();
          },
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: controller.courses.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 200),
                      Center(
                        child: Text(
                          "No courses available",
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppTheme.greyText
                                : AppTheme.textColorLight,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 32),
                    itemCount: controller.courses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final course = controller.courses[index];
                      return CourseTile(
                        course: course,
                        onTap: () {
                          NavigationHelper.push(
                            YearScreen(
                              courseId: course.id,
                              courseName: course.name,
                            ),
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     backgroundColor: Theme.of(
                          //       context,
                          //     ).colorScheme.surface,
                          //     content: Text(
                          //       "Selected: ${course.name}",
                          //       style: TextStyle(
                          //         color: Theme.of(
                          //           context,
                          //         ).colorScheme.onSurface,
                          //       ),
                          //     ),
                          //     behavior: SnackBarBehavior.floating,
                          //   ),
                          // );
                        },
                      );
                    },
                  ),
          ),
        );
      }),
    );
  }
}
