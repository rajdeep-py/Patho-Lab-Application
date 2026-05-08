import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';
import '../../providers/test_provider.dart';

class TestCard extends ConsumerWidget {
  final LabTest test;

  const TestCard({super.key, required this.test});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppCardStyles.sleekCard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/test-details', extra: test),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Enhanced Test Image with Gradient Overlay
                Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(30),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          test.photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: AppColors.background,
                                child: const Icon(
                                  IconsaxPlusLinear.image,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: test.isActive
                              ? AppColors.success
                              : AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (test.isActive
                                          ? AppColors.success
                                          : AppColors.error)
                                      .withAlpha(100),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Detailed Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.name,
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 16,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryCyan.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          test.category.toUpperCase(),
                          style: AppTextStyles.tagline.copyWith(
                            fontSize: 9,
                            color: AppColors.secondaryCyan,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '₹${test.price.toStringAsFixed(0)}',
                            style: AppTextStyles.cardTitle.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/ test',
                            style: AppTextStyles.caption.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Premium Actions
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: Switch.adaptive(
                        value: test.isActive,
                        activeTrackColor: AppColors.primary,
                        onChanged: (value) => ref
                            .read(testProvider.notifier)
                            .toggleTestStatus(test.id),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        IconsaxPlusLinear.arrow_right_3,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
