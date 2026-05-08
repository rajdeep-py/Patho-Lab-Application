import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final bool showMenuButton;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final List<Widget>? actions;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.showMenuButton = false,
    this.onBackTap,
    this.onMenuTap,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: _buildLeading(context),
      title: Column(
        crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.subHeader.copyWith(
              fontSize: 20,
              height: 1.2,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!.toUpperCase(),
              style: AppTextStyles.tagline.copyWith(
                fontSize: 10,
                letterSpacing: 1.0,
                color: AppColors.textTertiary,
              ),
            ),
        ],
      ),
      actions: [
        if (actions != null) ...actions!,
        const SizedBox(width: 8),
      ],
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (showBackButton) {
      return IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Icon(IconsaxPlusLinear.arrow_left_1, size: 20),
        ),
        onPressed: onBackTap ?? () => Navigator.maybePop(context),
      );
    }

    if (showMenuButton) {
      return IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Icon(IconsaxPlusLinear.menu_1, size: 20),
        ),
        onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
      );
    }

    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
