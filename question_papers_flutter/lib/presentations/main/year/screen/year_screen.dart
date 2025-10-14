import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/shimmer_list.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/main/subject/screen/subject_screen.dart';
import 'package:question_papers_flutter/presentations/main/year/controller/year_controller.dart';
import 'package:question_papers_flutter/presentations/main/year/model/semester_model.dart';
import 'package:question_papers_flutter/presentations/main/year/widgets/semester_tile.dart';

class YearScreen extends StatefulWidget {
  final String courseId; // required to load semesters for a specific course
  final String courseName;

  const YearScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  final YearController controller = Get.find<YearController>();
  bool showShimmer = false;

  @override
  void initState() {
    super.initState();
    // Load semesters when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWithAnimation();
    });
  }

  /// Ensures shimmer shows for at least 1 second (even if API returns quickly)
  Future<void> _loadWithAnimation() async {
    setState(() => showShimmer = true);
    final start = DateTime.now();

    await controller.loadSemesters(widget.courseId);

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
        title: Text(
          widget.courseName,
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
        final semesters = controller.semesters;

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
                    child: semesters.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 200),
                              Center(
                                child: Text(
                                  "No semesters available",
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
                            itemCount: semesters.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final SemesterModel semester = semesters[index];

                              return SemesterTile(
                                semester: semester,
                                onTap: () {
                                  NavigationHelper.push(
                                    SubjectScreen(
                                      subjectId: semester.id,
                                      subjectName: semester.name,
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
