import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../providers/earning_provider.dart';

class EarningFilterCard extends ConsumerWidget {
  const EarningFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningState = ref.watch(earningProvider);
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (index) => currentYear - index);
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(IconsaxPlusLinear.filter_edit, color: AppColors.primaryAccent, size: 20),
              const SizedBox(width: 12),
              Text('Filter Statements', style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
              const Spacer(),
              _buildDownloadButton(),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              // Year Dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Year', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                    const SizedBox(height: 8),
                    _buildDropdown<int>(
                      value: earningState.yearFilter,
                      items: years,
                      onChanged: (val) => ref.read(earningProvider.notifier).setFilters(year: val),
                      hint: 'Select Year',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Month Dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Month', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                    const SizedBox(height: 8),
                    _buildDropdown<int>(
                      value: earningState.monthFilter,
                      items: List.generate(12, (index) => index + 1),
                      itemLabel: (val) => months[val - 1],
                      onChanged: (val) => ref.read(earningProvider.notifier).setFilters(month: val),
                      hint: 'Select Month',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String hint,
    String Function(T)? itemLabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withAlpha(100)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: AppTextStyles.caption),
          icon: const Icon(IconsaxPlusLinear.arrow_down_1, size: 16),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel != null ? itemLabel(item) : item.toString(),
                style: AppTextStyles.description.copyWith(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return InkWell(
      onTap: () {
        // Trigger download logic
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.secondaryCyan.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(IconsaxPlusLinear.document_download, size: 18, color: AppColors.secondaryCyan),
      ),
    );
  }
}
