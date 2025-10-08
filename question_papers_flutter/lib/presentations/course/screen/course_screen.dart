import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/presentations/course/controller/course_controller.dart';
import 'package:question_papers_flutter/presentations/course/widgets/course_tile.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseController controller = Get.find<CourseController>();

    // Load courses when the screen first opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCourses();
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Courses",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.courses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadCourses();
          },
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: controller.courses.isEmpty
                ? ListView(
                    // Needed so RefreshIndicator can work even when list is empty
                    children: const [
                      SizedBox(height: 200),
                      Center(
                        child: Text(
                          "No courses available",
                          style: TextStyle(fontSize: 16),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Selected: ${course.name}"),
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
