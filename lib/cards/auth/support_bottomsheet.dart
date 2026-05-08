import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';

class SupportBottomSheet extends StatelessWidget {
  const SupportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.borderRadius),
          topRight: Radius.circular(AppSpacing.borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Contact Support',
            style: AppTextStyles.subHeader,
          ),
          const SizedBox(height: 8),
          const Text(
            'How can we help you today?',
            style: AppTextStyles.description,
          ),
          const SizedBox(height: 24),
          _SupportOption(
            icon: IconsaxPlusLinear.call,
            title: 'Call Support',
            subtitle: '+1 (800) 123-4567',
            onTap: () {
              // Handle call
            },
          ),
          const SizedBox(height: 12),
          _SupportOption(
            icon: IconsaxPlusLinear.sms,
            title: 'Email Support',
            subtitle: 'support@patholab.com',
            onTap: () {
              // Handle email
            },
          ),
          const SizedBox(height: 12),
          _SupportOption(
            icon: IconsaxPlusLinear.global,
            title: 'Website Support',
            subtitle: 'www.patholab.com/help',
            onTap: () {
              // Handle website
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SupportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SupportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const Icon(IconsaxPlusLinear.arrow_right_3, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}
