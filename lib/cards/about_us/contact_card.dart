import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class AboutContactCard extends StatelessWidget {
  final AboutUs data;

  const AboutContactCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.elementGap,
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppCardStyles.primaryGradientCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(IconsaxPlusLinear.call, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text('Contact Us', style: AppTextStyles.cardTitle.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildRow(IconsaxPlusLinear.call_calling, 'Phone', data.phone),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white24, height: 1),
          ),
          _buildRow(IconsaxPlusLinear.sms, 'Email', data.email),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white24, height: 1),
          ),
          _buildRow(IconsaxPlusLinear.global, 'Website', data.website),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white24, height: 1),
          ),
          _buildRow(IconsaxPlusLinear.location, 'Address', data.address),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.description.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
