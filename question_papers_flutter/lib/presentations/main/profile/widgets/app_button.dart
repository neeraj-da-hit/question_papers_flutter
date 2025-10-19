import 'package:flutter/material.dart';
import 'package:question_papers_flutter/common/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;
  final bool outlined;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.icon,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = outlined
        ? Colors.transparent
        : primaryColor.withOpacity(isDark ? 0.25 : 0.1);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.defaultPadding,
        vertical: 8,
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: bgColor,
          foregroundColor: primaryColor,
          side: outlined
              ? BorderSide(color: primaryColor.withOpacity(0.5))
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
          ),
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: outlined
                ? primaryColor
                : (isDark ? AppTheme.textColorDark : primaryColor),
          ),
        ),
      ),
    );
  }
}
