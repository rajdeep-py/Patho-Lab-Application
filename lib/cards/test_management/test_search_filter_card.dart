import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../providers/test_provider.dart';

class TestSearchFilterCard extends ConsumerWidget {
  const TestSearchFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppCardStyles.sleekCard.copyWith(
        gradient: LinearGradient(
          colors: [AppColors.surface, AppColors.background.withAlpha(150)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => ref.read(testProvider.notifier).setSearchQuery(value),
                  style: const TextStyle(fontFamily: 'Lexend', fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search for lab tests...',
                    prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1, size: 22, color: AppColors.primaryAccent),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.divider.withAlpha(100)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(IconsaxPlusLinear.filter_edit, color: AppColors.primaryAccent, size: 24),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.elementGap),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Hematology', 'Biochemistry', 'Endocrinology', 'Microbiology']
                  .map((String category) {
                final isSelected = (ref.watch(testProvider).categoryFilter ?? 'All') == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    onSelected: (selected) => ref.read(testProvider.notifier).setCategoryFilter(category),
                    labelStyle: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primaryAccent,
                    checkmarkColor: Colors.white,
                    side: BorderSide(color: isSelected ? Colors.transparent : AppColors.divider),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: isSelected ? 4 : 0,
                    pressElevation: 0,
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
