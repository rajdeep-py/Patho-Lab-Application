import 'package:flutter/material.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';

class TestPrecautionsCard extends StatelessWidget {
  final LabTest test;

  const TestPrecautionsCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    if (test.precautions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.elementGap),
      decoration: AppCardStyles.sleekCard.copyWith(
        border: Border.all(color: AppColors.warning.withAlpha(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                const SizedBox(width: AppSpacing.elementGap),
                Text(
                  'Test Precautions',
                  style: AppTextStyles.cardTitle.copyWith(color: AppColors.warning),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.elementGap),
            ...test.precautions.map((precaution) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: AppTextStyles.description.copyWith(color: AppColors.warning)),
                  Expanded(
                    child: Text(
                      precaution,
                      style: AppTextStyles.description,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
