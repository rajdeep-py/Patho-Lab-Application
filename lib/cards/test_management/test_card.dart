import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/test.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';

class TestCard extends ConsumerWidget {
  final LabTest test;

  const TestCard({super.key, required this.test});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.elementGap),
      decoration: AppCardStyles.sleekCard,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          onTap: () {
            context.push('/test-details', extra: test);
          },
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                Hero(
                  tag: 'test_image_${test.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _buildTestImage(test.photoUrl),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.cardPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          test.category.toUpperCase(),
                          style: AppTextStyles.tagline.copyWith(fontSize: 10, letterSpacing: 1.0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        test.name,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 18, height: 1.2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '₹${test.price.toStringAsFixed(2)}',
                            style: AppTextStyles.subHeader.copyWith(color: AppColors.primaryAccent, fontSize: 20),
                          ),
                          const Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(IconsaxPlusLinear.trash, color: AppColors.errorLight, size: 22),
                            onPressed: () {
                              _showDeleteConfirmation(context, ref);
                            },
                          ),
                          const SizedBox(width: 12),
                          const Icon(IconsaxPlusLinear.arrow_right_3, color: AppColors.primary, size: 22),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOut).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut);
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lab Test', style: AppTextStyles.cardTitle),
        content: Text('Are you sure you want to delete ${test.name}?', style: AppTextStyles.description),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cardRadius)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(testProvider.notifier).deleteTest(test.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${test.name} deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildTestImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, width: 90, height: 90, fit: BoxFit.cover, errorBuilder: _errorBuilder);
    } else if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        return Image.memory(base64Decode(base64Str), width: 90, height: 90, fit: BoxFit.cover, errorBuilder: _errorBuilder);
      } catch (e) {
        return _buildErrorPlaceholder();
      }
    } else {
      if (kIsWeb || url.isEmpty) {
        return _buildErrorPlaceholder();
      }
      return Image.file(File(url), width: 90, height: 90, fit: BoxFit.cover, errorBuilder: _errorBuilder);
    }
  }

  Widget _errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: 90,
      height: 90,
      color: AppColors.blush,
      child: const Icon(IconsaxPlusLinear.activity, color: AppColors.textTertiary),
    );
  }
}
