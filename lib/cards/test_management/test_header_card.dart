import 'package:flutter/material.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';

class TestHeaderCard extends StatelessWidget {
  final LabTest test;

  const TestHeaderCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.elementGap),
      decoration: AppCardStyles.sleekCard,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.elementGap),
              child: Image.network(
                test.photoUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 200,
                  color: AppColors.blush,
                  child: const Icon(Icons.science, color: AppColors.textTertiary, size: 50),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.cardPadding),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withAlpha(50)),
              ),
              child: Text(
                test.category.toUpperCase(),
                style: AppTextStyles.tagline,
              ),
            ),
            const SizedBox(height: AppSpacing.elementGap),
            Text(
              test.name,
              style: AppTextStyles.header.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${test.price.toStringAsFixed(2)}',
              style: AppTextStyles.subHeader.copyWith(color: AppColors.primaryAccent),
            ),
          ],
        ),
      ),
    );
  }
}
