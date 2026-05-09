import 'package:flutter/material.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';

class TestDescriptionCard extends StatelessWidget {
  final LabTest test;

  const TestDescriptionCard({super.key, required this.test});

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
            const Text(
              'Detailed Description',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: AppSpacing.elementGap),
            Text(
              test.detailedDescription,
              style: AppTextStyles.description,
            ),
            if (test.parameters.isNotEmpty) ...[
              const Divider(height: AppSpacing.sectionGap, color: AppColors.divider),
              const Text(
                'Parameters Included',
                style: AppTextStyles.cardTitle,
              ),
              const SizedBox(height: AppSpacing.elementGap),
              ...test.parameters.map((param) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.elementGap),
                    Expanded(child: Text(param, style: AppTextStyles.description)),
                  ],
                ),
              )).toList(),
            ],
          ],
        ),
      ),
    );
  }
}
