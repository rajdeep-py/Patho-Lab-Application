import 'package:flutter/material.dart';
import '../../models/terms_conditions.dart';
import '../../theme/app_theme.dart';

class TermsConditionsCard extends StatelessWidget {
  final TermsCondition termsCondition;

  const TermsConditionsCard({super.key, required this.termsCondition});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.elementGap),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            termsCondition.title,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 12),
          Text(
            termsCondition.content,
            style: AppTextStyles.description,
          ),
        ],
      ),
    );
  }
}
