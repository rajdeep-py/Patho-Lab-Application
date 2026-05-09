import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';
import '../../cards/test_management/test_header_card.dart';
import '../../cards/test_management/test_description_card.dart';
import '../../cards/test_management/test_precautions_card.dart';
import '../../cards/test_management/test_collection_delivery_card.dart';
import '../../providers/test_provider.dart';

class TestDetailsScreen extends ConsumerWidget {
  final LabTest test;

  const TestDetailsScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Test Details', style: AppTextStyles.subHeader.copyWith(fontSize: 20)),
            Text(test.name, style: AppTextStyles.caption),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {
              context.push('/create-edit-test', extra: test);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {
              _showDeleteConfirmation(context, ref);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
        child: Column(
          children: [
            TestHeaderCard(test: test),
            TestDescriptionCard(test: test),
            TestPrecautionsCard(test: test),
            TestCollectionDeliveryCard(test: test),
          ],
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
              context.pop(); // Go back to management screen
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
}
