import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/presentations/year/controller/year_controller.dart';
import 'package:question_papers_flutter/presentations/year/model/semester_model.dart';
import 'package:question_papers_flutter/presentations/year/widgets/semester_tile.dart';

class YearScreen extends StatelessWidget {
  final String courseId; // required to load semesters for a specific course
  final String courseName;
  const YearScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    final YearController controller = Get.put(YearController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Load semesters when the screen first opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadSemesters(courseId);
    });

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          courseName,
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
        if (controller.isLoading.value && controller.semesters.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadSemesters(courseId);
          },
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: controller.semesters.isEmpty
                ? ListView(
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
                    itemCount: controller.semesters.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final SemesterModel semester =
                          controller.semesters[index];

                      return SemesterTile(
                        semester: semester,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Selected: ${semester.name}"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
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
