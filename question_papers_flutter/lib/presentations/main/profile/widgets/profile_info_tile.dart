import 'package:flutter/material.dart';
import 'package:question_papers_flutter/common/app_theme.dart';

class ProfileInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final bool showDivider;
  final IconData? icon;
  final VoidCallback? onTap;

  const ProfileInfoTile({
    super.key,
    required this.title,
    required this.value,
    this.showDivider = true,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 🎨 Adaptive colors
    final textColor = isDark ? AppTheme.textColorDark : AppTheme.textColorLight;
    final titleColor = isDark ? Colors.grey[400] : AppTheme.greyText;

    // 🧩 Subtle adaptive background (surface-like tone)
    final tileColor = isDark
        ? AppTheme.backgroundDark.withOpacity(0.6)
        : AppTheme.backgroundLight.withOpacity(0.9);

    // 🧭 Divider + ripple colors
    final dividerColor = isDark
        ? Colors.white.withOpacity(0.12)
        : AppTheme.greyText.withOpacity(0.2);

    final splashColor = theme.colorScheme.primary.withOpacity(
      isDark ? 0.15 : 0.08,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        splashColor: splashColor,
        child: Container(
          decoration: BoxDecoration(
            color: tileColor,
            // borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: AppTheme.defaultPadding,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🏷️ Title
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          color: titleColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    // 💬 Value
                    Flexible(
                      flex: 2,
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),

                    // ➕ Optional icon
                    if (icon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(icon, size: 18, color: titleColor),
                      ),
                  ],
                ),
              ),
              if (showDivider)
                Divider(
                  height: 1,
                  thickness: 0.6,
                  color: dividerColor,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
