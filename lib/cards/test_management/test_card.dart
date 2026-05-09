import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.elementGap),
                  child: _buildTestImage(test.photoUrl),
                ),
                const SizedBox(width: AppSpacing.cardPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.category.toUpperCase(),
                        style: AppTextStyles.tagline,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        test.name,
                        style: AppTextStyles.cardTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${test.price.toStringAsFixed(2)}',
                        style: AppTextStyles.subHeader.copyWith(color: AppColors.primaryAccent, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(IconsaxPlusLinear.trash, color: AppColors.error),
                  onPressed: () {
                    _showDeleteConfirmation(context, ref);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      return Image.network(url, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: _errorBuilder);
    } else if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        return Image.memory(base64Decode(base64Str), width: 80, height: 80, fit: BoxFit.cover, errorBuilder: _errorBuilder);
      } catch (e) {
        return _buildErrorPlaceholder();
      }
    } else {
      if (kIsWeb || url.isEmpty) {
        return _buildErrorPlaceholder();
      }
      return Image.file(File(url), width: 80, height: 80, fit: BoxFit.cover, errorBuilder: _errorBuilder);
    }
  }

  Widget _errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: AppColors.blush,
      child: const Icon(IconsaxPlusLinear.activity, color: AppColors.textTertiary),
    );
  }
}
