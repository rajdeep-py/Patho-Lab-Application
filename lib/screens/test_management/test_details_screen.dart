import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
    final updatedTest = ref.watch(testProvider).firstWhere(
      (t) => t.id == test.id,
      orElse: () => test,
    );

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
            Text(updatedTest.name, style: AppTextStyles.caption),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.trash, color: AppColors.error),
            onPressed: () {
              _showDeleteConfirmation(context, ref, updatedTest);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
        child: Column(
          children: [
            TestHeaderCard(test: updatedTest),
            TestDescriptionCard(test: updatedTest),
            TestPrecautionsCard(test: updatedTest),
            TestCollectionDeliveryCard(test: updatedTest),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, LabTest currentTest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lab Test', style: AppTextStyles.cardTitle),
        content: Text('Are you sure you want to delete ${currentTest.name}?', style: AppTextStyles.description),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cardRadius)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(testProvider.notifier).deleteTest(currentTest.id);
              Navigator.pop(context);
              context.pop(); // Go back to management screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${currentTest.name} deleted successfully')),
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
