import 'package:flutter/material.dart';
import '../../models/privacy_policy.dart';
import '../../theme/app_theme.dart';

class PrivacyPolicyCard extends StatelessWidget {
  final PrivacyPolicy privacyPolicy;

  const PrivacyPolicyCard({super.key, required this.privacyPolicy});

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
            privacyPolicy.title,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 12),
          Text(
            privacyPolicy.content,
            style: AppTextStyles.description,
          ),
        ],
      ),
    );
  }
}
