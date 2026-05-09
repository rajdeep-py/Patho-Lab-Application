import 'package:flutter/material.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class AboutHeaderCard extends StatelessWidget {
  final AboutUs data;

  const AboutHeaderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.elementGap,
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding * 1.5),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/logo/logo.png',
              width: 80,
              height: 80,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if logo doesn't exist
                return const Icon(
                  Icons.medical_services_rounded,
                  size: 80,
                  color: AppColors.primary,
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.cardPadding),
          Text(
            data.companyName,
            style: AppTextStyles.header.copyWith(fontSize: 26),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.secondaryCyan.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.tagline,
              style: AppTextStyles.subHeader.copyWith(
                color: AppColors.secondaryCyan,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
