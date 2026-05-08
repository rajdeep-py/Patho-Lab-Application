import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../providers/test_provider.dart';

class PickTestSearchCard extends ConsumerWidget {
  const PickTestSearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppCardStyles.sleekCard.copyWith(
        gradient: LinearGradient(
          colors: [AppColors.primary.withAlpha(20), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FIND NEW TESTS',
            style: AppTextStyles.tagline.copyWith(fontSize: 10, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => ref.read(testProvider.notifier).setSearchQuery(value),
            style: const TextStyle(fontFamily: 'Lexend', fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Enter test name or category...',
              prefixIcon: const Icon(IconsaxPlusLinear.search_status, size: 22, color: AppColors.primary),
              suffixIcon: const Icon(IconsaxPlusLinear.microphone_2, size: 20, color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.surface,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.divider.withAlpha(100)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
