import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../providers/package_provider.dart';
import '../../theme/app_theme.dart';

class PackageSearchCard extends ConsumerWidget {
  const PackageSearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.elementGap),
      decoration: AppCardStyles.sleekCard,
      child: TextField(
        onChanged: (value) {
          ref.read(packageSearchQueryProvider.notifier).state = value;
        },
        decoration: const InputDecoration(
          hintText: 'Search health packages...',
          prefixIcon: Icon(IconsaxPlusLinear.search_normal, color: AppColors.textTertiary),
        ),
      ),
    );
  }
}
