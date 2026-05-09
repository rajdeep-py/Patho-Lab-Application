import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../widgets/app_bar.dart';
import '../../theme/app_theme.dart';
import '../../cards/earning/company_earning_card.dart';

class CompanyEarningHistoryScreen extends StatelessWidget {
  const CompanyEarningHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for company earnings
    final dummyHistory = [
      {
        'id': 'TXN-9901',
        'amount': 45000.00,
        'isCredit': true,
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'breakdown': {
          'Base Settlement': 42000.00,
          'Bonus Commission': 3500.00,
          'Adjustments': -500.00,
        },
      },
      {
        'id': 'TXN-9902',
        'amount': 12000.00,
        'isCredit': false,
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'breakdown': {
          'Equipment Lease': 10000.00,
          'Software Subscription': 2000.00,
        },
      },
      {
        'id': 'TXN-9903',
        'amount': 28500.00,
        'isCredit': true,
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'breakdown': {'Weekly Settlement': 28500.00},
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Company Earnings',
        subtitle: 'Official settlement history',
        showBackButton: true,
        actions: [
          IconButton(
            onPressed: () => _showDownloadOptions(context),
            icon: const Icon(
              IconsaxPlusLinear.document_download,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: dummyHistory.length,
        itemBuilder: (context, index) {
          final item = dummyHistory[index];
          return CompanyEarningCard(
            transactionId: item['id'] as String,
            amount: item['amount'] as double,
            isCredit: item['isCredit'] as bool,
            date: item['date'] as DateTime,
            breakdown: item['breakdown'] as Map<String, double>,
          );
        },
      ),
    );
  }

  void _showDownloadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Download Statement',
                style: AppTextStyles.subHeader.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the duration for your financial report',
                style: AppTextStyles.description.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),
              _DownloadOption(
                title: 'Daily Report',
                subtitle: 'Statement for the current day',
                icon: IconsaxPlusLinear.calendar,
                onTap: () => Navigator.pop(context),
              ),
              _DownloadOption(
                title: 'Weekly Report',
                subtitle: 'Summary of the last 7 days',
                icon: IconsaxPlusLinear.calendar_1,
                onTap: () => Navigator.pop(context),
              ),
              _DownloadOption(
                title: 'Monthly Report',
                subtitle: 'Complete monthly transaction list',
                icon: IconsaxPlusLinear.calendar_2,
                onTap: () => Navigator.pop(context),
              ),
              _DownloadOption(
                title: 'Yearly Report',
                subtitle: 'Annual settlement overview',
                icon: IconsaxPlusLinear.calendar_tick,
                onTap: () => Navigator.pop(context),
              ),
              _DownloadOption(
                title: 'Custom Report',
                subtitle: 'Select a custom date range',
                icon: IconsaxPlusLinear.calendar_add,
                onTap: () async {
                  Navigator.pop(context); // Close bottom sheet
                  final DateTimeRange? range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primaryAccent,
                            onPrimary: Colors.white,
                            onSurface: AppColors.textPrimary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (range != null) {
                    // Logic to handle downloaded report for range
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading report for ${range.start.day}/${range.start.month} - ${range.end.day}/${range.end.month}'),
                        backgroundColor: AppColors.primaryAccent,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _DownloadOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryAccent.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primaryAccent, size: 24),
      ),
      title: Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(
        IconsaxPlusLinear.arrow_right_3,
        size: 18,
        color: AppColors.textTertiary,
      ),
    );
  }
}
