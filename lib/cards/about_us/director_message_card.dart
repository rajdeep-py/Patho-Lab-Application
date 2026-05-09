import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class DirectorMessageCard extends StatelessWidget {
  final AboutUs data;

  const DirectorMessageCard({super.key, required this.data});

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
          Row(
            children: [
              const Icon(IconsaxPlusLinear.quote_down, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text('Message from Director', style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: AppSpacing.elementGap),
          Text(
            '"${data.directorMessage}"',
            style: AppTextStyles.description.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  data.directorPhotoUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: AppColors.blush,
                      child: const Icon(IconsaxPlusLinear.user, color: AppColors.textTertiary),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.directorName, style: AppTextStyles.subHeader.copyWith(fontSize: 16)),
                    Text(
                      'Managing Director',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
