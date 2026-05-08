import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/earning_provider.dart';
import '../../cards/earning/earning_filter_card.dart';
import '../../cards/earning/earning_card.dart';

class EarningScreen extends ConsumerWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningState = ref.watch(earningProvider);
    final filteredEarnings = earningState.earnings.where((earning) {
      bool matchesYear = earningState.yearFilter == null || earning.periodStart.year == earningState.yearFilter;
      bool matchesMonth = earningState.monthFilter == null || earning.periodStart.month == earningState.monthFilter;
      return matchesYear && matchesMonth;
    }).toList();

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: const CustomAppBar(
        title: 'Earnings',
        subtitle: 'Payments and financial statements',
        showMenuButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EarningFilterCard(),
            const SizedBox(height: 32),
            Text(
              'Payment Records',
              style: AppTextStyles.subHeader.copyWith(fontSize: 18),
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
            child: Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          Text('No financial records found for this period', style: AppTextStyles.description),
        ],
      ),
    );
  }
}
