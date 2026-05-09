import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../providers/medicine_provider.dart';

class MedicineSearchFilterCard extends ConsumerWidget {
  const MedicineSearchFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        children: [
          TextField(
            onChanged: (value) => ref.read(medicineProvider.notifier).setSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'Search medicines...',
              prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1, size: 20),
              suffixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(IconsaxPlusLinear.setting_4, size: 16, color: AppColors.primaryAccent),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All Prices',
                  isSelected: ref.watch(medicineProvider).maxPriceFilter == null,
                  onTap: () => ref.read(medicineProvider.notifier).setPriceFilter(null),
                ),
                _FilterChip(
                  label: 'Under ₹50',
                  isSelected: ref.watch(medicineProvider).maxPriceFilter == 50,
                  onTap: () => ref.read(medicineProvider.notifier).setPriceFilter(50),
                ),
                _FilterChip(
                  label: 'Under ₹100',
                  isSelected: ref.watch(medicineProvider).maxPriceFilter == 100,
                  onTap: () => ref.read(medicineProvider.notifier).setPriceFilter(100),
                ),
                _FilterChip(
                  label: 'Under ₹500',
                  isSelected: ref.watch(medicineProvider).maxPriceFilter == 500,
                  onTap: () => ref.read(medicineProvider.notifier).setPriceFilter(500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
