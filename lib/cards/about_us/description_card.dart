import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class AboutDescriptionCard extends StatelessWidget {
  final AboutUs data;

  const AboutDescriptionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.elementGap,
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About Us', style: AppTextStyles.cardTitle),
          const SizedBox(height: AppSpacing.elementGap),
          Text(
            data.description,
            style: AppTextStyles.description,
            textAlign: TextAlign.justify,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sectionGap),
            child: Divider(color: AppColors.divider),
          ),
          _buildSection(IconsaxPlusLinear.directbox_send, 'Our Mission', data.mission),
          const SizedBox(height: AppSpacing.cardPadding),
          _buildSection(IconsaxPlusLinear.eye, 'Our Vision', data.vision),
        ],
      ),
    );
  }

  Widget _buildSection(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.subHeader.copyWith(fontSize: 16)),
              const SizedBox(height: 6),
              Text(
                content,
                style: AppTextStyles.caption.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
