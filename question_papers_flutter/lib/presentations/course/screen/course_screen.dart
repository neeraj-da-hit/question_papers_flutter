import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/shimmer_list.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/course/controller/course_controller.dart';
import 'package:question_papers_flutter/presentations/course/widgets/course_tile.dart';
import 'package:question_papers_flutter/presentations/year/screen/year_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final CourseController controller = Get.find<CourseController>();
  bool showShimmer = false;

  @override
  void initState() {
    super.initState();
    // Load data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWithAnimation();
    });
  }

  /// Loads courses and ensures shimmer shows for at least 1 second
  Future<void> _loadWithAnimation() async {
    setState(() => showShimmer = true);
    final start = DateTime.now();

    await controller.loadCourses();

    // ensure shimmer stays visible at least 1 second
    final diff = DateTime.now().difference(start);
    final delay = diff.inMilliseconds < 1000 ? 1000 - diff.inMilliseconds : 0;
    await Future.delayed(Duration(milliseconds: delay));

    if (mounted) setState(() => showShimmer = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        elevation: 0,
      ),
      body: Obx(() {
        final courses = controller.courses;

        return RefreshIndicator(
          onRefresh: _loadWithAnimation,
          color: Theme.of(context).colorScheme.primary,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: showShimmer
                ? ListView.separated(
                    key: const ValueKey('shimmer'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    itemCount: 10,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, __) => const ShimmerList(),
                  )
                : Padding(
                    key: const ValueKey('list'),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: courses.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
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
                            itemCount: courses.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final course = courses[index];
                              return CourseTile(
                                course: course,
                                onTap: () {
                                  NavigationHelper.push(
                                    YearScreen(
                                      courseId: course.id,
                                      courseName: course.name,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
          ),
        );
      }),
    );
  }
}
