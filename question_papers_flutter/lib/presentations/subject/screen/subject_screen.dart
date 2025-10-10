import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/shimmer_list.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';
import 'package:question_papers_flutter/presentations/subject/controller/subject_controller.dart';
import 'package:question_papers_flutter/presentations/subject/model/subject_model.dart';
import 'package:question_papers_flutter/presentations/subject/widgets/SubjectTile.dart';

class SubjectScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  const SubjectScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final SubjectController controller = Get.find<SubjectController>();
  bool showShimmer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWithAnimation();
    });
  }

  /// Load with shimmer animation for at least 1s
  Future<void> _loadWithAnimation() async {
    setState(() => showShimmer = true);
    final start = DateTime.now();

    await controller.laodSubjects(widget.subjectId);

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
          widget.subjectName,
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
        final subjects = controller.subjects;

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
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, __) => const ShimmerList(),
                  )
                : Padding(
                    key: const ValueKey('list'),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: subjects.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 200),
                              Center(
                                child: Text(
                                  "No subjects available",
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
                            itemCount: subjects.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final SubjectModel subject = subjects[index];

                              return SubjectTile(
                                subject: subject,
                                onTap: () {
                                  NavigationHelper.push(
                                    SubjectScreen(
                                      subjectId: subject.id,
                                      subjectName: subject.name,
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
