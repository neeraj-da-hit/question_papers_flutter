import 'package:flutter/material.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/presentations/main/subject/model/subject_model.dart';

class SubjectTile extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback? onTap;

  const SubjectTile({super.key, required this.subject, this.onTap});

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

        title: Text(
          subject.name,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
          ),
        ),

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
