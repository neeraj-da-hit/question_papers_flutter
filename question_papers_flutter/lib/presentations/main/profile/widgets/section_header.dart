import 'package:flutter/material.dart';
import 'package:question_papers_flutter/common/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool showBackground;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Adaptive background and text colors
    final bgColor = showBackground
        ? (isDark
              ? AppTheme.backgroundDark.withOpacity(0.6)
              : AppTheme.backgroundLight.withOpacity(1))
        : Colors.transparent;

    final textColor = isDark ? AppTheme.textColorDark : AppTheme.greyText;
    final iconColor = isDark ? Colors.grey[400] : AppTheme.greyText;

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: AppTheme.defaultPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 18, color: iconColor),
          if (icon != null) const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: textColor,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
