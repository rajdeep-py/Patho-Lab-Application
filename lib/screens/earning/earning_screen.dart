import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/earning_provider.dart';
import '../../cards/earning/earning_card.dart';
import '../../cards/earning/claim_pay_earning_card.dart';

class EarningScreen extends ConsumerWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningState = ref.watch(earningProvider);
    final filteredEarnings = earningState.earnings.where((earning) {
      bool matchesYear =
          earningState.yearFilter == null ||
          earning.date.year == earningState.yearFilter;
      bool matchesMonth =
          earningState.monthFilter == null ||
          earning.date.month == earningState.monthFilter;
      return matchesYear && matchesMonth;
    }).toList();

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Payments & Earnings',
        subtitle: 'Financial statements and order breakdowns',
        showMenuButton: true,
        actions: [
          IconButton(
            onPressed: () {
              // Open filter logic
            },
            icon: const Icon(
              IconsaxPlusLinear.filter_edit,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ClaimPayEarningCard(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Breakdown',
                  style: AppTextStyles.subHeader.copyWith(fontSize: 18),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(IconsaxPlusLinear.calendar_1, size: 16),
                  label: Text(
                    '${earningState.monthFilter}/${earningState.yearFilter}',
                    style: AppTextStyles.tagline.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (filteredEarnings.isEmpty)
              _buildEmptyState()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredEarnings.length,
                itemBuilder: (context, index) {
                  return EarningCard(earning: filteredEarnings[index]);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Opacity(
            opacity: 0.4,
            child: Icon(
              IconsaxPlusLinear.receipt_item,
              size: 64,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No financial records found for this period',
            style: AppTextStyles.description,
          ),
        ],
      ),
    );
  }
}
