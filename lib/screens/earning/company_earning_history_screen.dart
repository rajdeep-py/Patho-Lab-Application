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
        'breakdown': {
          'Weekly Settlement': 28500.00,
        },
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
            onPressed: () {},
            icon: const Icon(IconsaxPlusLinear.export_1, color: AppColors.textPrimary),
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
}
