import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';
import '../../cards/test_management/test_header_card.dart';
import '../../cards/test_management/test_description_card.dart';
import '../../cards/test_management/test_precautions_card.dart';
import '../../cards/test_management/test_collection_delivery_card.dart';
import '../../providers/test_provider.dart';
import '../../widgets/app_bar.dart';

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
      appBar: CustomAppBar(
        title: 'Test Details',
        subtitle: updatedTest.name,
        showBackButton: true,
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
            TestDescriptionCard(test: updatedTest).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),
            TestPrecautionsCard(test: updatedTest).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1),
            TestCollectionDeliveryCard(test: updatedTest).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1),
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
