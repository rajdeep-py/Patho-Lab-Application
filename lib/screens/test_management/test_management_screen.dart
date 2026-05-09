import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';
import '../../cards/test_management/test_search_filter_card.dart';
import '../../cards/test_management/test_card.dart';

class TestManagementScreen extends ConsumerWidget {
  const TestManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(filteredTestsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Test Management', style: AppTextStyles.subHeader),
            Text('Manage all lab tests', style: AppTextStyles.caption),
          ],
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.primary),
            onPressed: () {
              // Handle download action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const TestSearchFilterCard(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
              itemCount: tests.length,
              itemBuilder: (context, index) {
                return TestCard(test: tests[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
