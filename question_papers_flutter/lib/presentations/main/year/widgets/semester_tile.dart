import 'package:flutter/material.dart';
import 'package:question_papers_flutter/presentations/main/year/model/semester_model.dart';
import 'package:question_papers_flutter/common/app_theme.dart';

class SemesterTile extends StatelessWidget {
  final SemesterModel semester;
  final VoidCallback? onTap;

  const SemesterTile({super.key, required this.semester, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
      ),
      elevation: isDark ? 0.5 : 1,
      shadowColor: isDark ? Colors.white10 : Colors.black12,
      color: isDark ? AppTheme.backgroundDark.withOpacity(0.8) : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

        // leading: CircleAvatar(
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   child: Text(
        //     semester.name.split(' ').last, // e.g., "1" from "Semester 1"
        //     style: const TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        title: Text(
          semester.name,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
          ),
        ),

        // subtitle: Text(
        //   "Course ID: ${semester.course}",
        //   style: TextStyle(
        //     fontSize: 13,
        //     color: isDark
        //         ? AppTheme.greyText.withOpacity(0.7)
        //         : AppTheme.greyText,
        //   ),
        // ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: isDark ? Colors.grey[400] : Colors.grey,
        ),

        onTap: onTap,
      ),
    );
  }
}
