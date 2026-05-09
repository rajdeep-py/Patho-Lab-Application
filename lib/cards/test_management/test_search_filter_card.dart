import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';

class TestSearchFilterCard extends ConsumerWidget {
  const TestSearchFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ['All', 'Blood Test', 'Heart Test', 'Sugar Test', 'Thyroid'];
    final selectedCategory = ref.watch(testCategoryFilterProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.elementGap),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    ref.read(testSearchQueryProvider.notifier).state = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search lab tests...',
                    prefixIcon: Icon(IconsaxPlusLinear.search_normal, color: AppColors.textTertiary),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.elementGap),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/create-edit-test');
                },
                icon: const Icon(IconsaxPlusLinear.add),
                label: const Text('New Test'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.elementGap),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      ref.read(testCategoryFilterProvider.notifier).state = category;
                    },
                    selectedColor: AppColors.primary.withAlpha(50),
                    checkmarkColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.divider),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontFamily: 'Lexend',
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
