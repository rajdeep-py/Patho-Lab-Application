import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/test_provider.dart';
import '../../cards/test_management/test_search_filter_card.dart';
import '../../cards/test_management/test_card.dart';

class TestManagementScreen extends ConsumerWidget {
  const TestManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testState = ref.watch(testProvider);
    final filteredTests = testState.inventory.where((test) {
      final matchesSearch = testState.searchQuery == null ||
          test.name.toLowerCase().contains(testState.searchQuery!.toLowerCase());
      final matchesCategory = testState.categoryFilter == null ||
          testState.categoryFilter == 'All' ||
          test.category == testState.categoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      drawer: const SideNavBar(),
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Test Center',
        subtitle: 'Catalogue Management',
        showMenuButton: true,
        actions: [
          _buildAddButton(context),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient Decor
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(20),
              ),
            ),
          ),
          RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                kToolbarHeight + 40,
                AppSpacing.screenPadding,
                100,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TestSearchFilterCard(),
                  const SizedBox(height: 32),
                  
                  // Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Catalog',
                            style: AppTextStyles.subHeader.copyWith(fontSize: 22),
                          ),
                          Text(
                            '${filteredTests.length} tests active in inventory',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                      if (testState.categoryFilter != null && testState.categoryFilter != 'All')
                        Chip(
                          label: Text(testState.categoryFilter!),
                          onDeleted: () => ref.read(testProvider.notifier).setCategoryFilter('All'),
                          deleteIcon: const Icon(IconsaxPlusLinear.close_circle, size: 16),
                          backgroundColor: AppColors.primary.withAlpha(30),
                          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.primaryAccent, fontWeight: FontWeight.bold),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  if (filteredTests.isEmpty)
                    _buildEmptyState(context)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTests.length,
                      itemBuilder: (context, index) {
                        return TestCard(test: filteredTests[index]);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAddButton(context, isFab: true),
    );
  }

  Widget _buildAddButton(BuildContext context, {bool isFab = false}) {
    if (isFab) {
      return FloatingActionButton.extended(
        onPressed: () => context.push('/pick-test'),
        backgroundColor: AppColors.primaryAccent,
        icon: const Icon(IconsaxPlusLinear.add, color: Colors.white),
        label: const Text('Add Test', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
    }
    return IconButton(
      onPressed: () => context.push('/pick-test'),
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(40),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.divider.withAlpha(100)),
        ),
        child: const Icon(IconsaxPlusLinear.add, color: AppColors.primaryAccent, size: 20),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 40,
                ),
              ],
            ),
            child: Icon(IconsaxPlusLinear.search_status, size: 80, color: AppColors.textTertiary.withAlpha(100)),
          ),
          const SizedBox(height: 24),
          Text('No tests found in your inventory', style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          Text(
            'Start by adding tests from our master list\nto populate your lab services.',
            textAlign: TextAlign.center,
            style: AppTextStyles.description.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.push('/pick-test'),
            icon: const Icon(IconsaxPlusLinear.add_square, size: 20),
            label: const Text('Pick Tests to Add'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
