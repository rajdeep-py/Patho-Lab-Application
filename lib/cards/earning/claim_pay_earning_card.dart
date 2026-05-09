import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../providers/earning_provider.dart';

class ClaimPayEarningCard extends ConsumerWidget {
  const ClaimPayEarningCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningState = ref.watch(earningProvider);

    return Container(
      decoration: AppCardStyles.sleekCard,
      child: Column(
        children: [
          _buildSection(
            context,
            title: 'Amount to be Paid',
            amount: earningState.totalToBePaid,
            subtitle: 'Collected during sample collection',
            icon: IconsaxPlusLinear.wallet_add,
            color: AppColors.primaryAccent,
            buttonLabel: 'PAY NOW',
            onButtonPressed: () {
              // Implementation for Payment
            },
          ),
          Divider(height: 1, color: AppColors.divider.withAlpha(120)),
          _buildSection(
            context,
            title: 'Amount to be Claimed',
            amount: earningState.totalToBeClaimed,
            subtitle: 'Paid by customers via online',
            icon: IconsaxPlusLinear.wallet_check,
            color: AppColors.success,
            buttonLabel: 'CLAIM NOW',
            onButtonPressed: () {
              // Implementation for Claiming
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required double amount,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String buttonLabel,
    VoidCallback? onButtonPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  '₹${amount.toStringAsFixed(2)}',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 22, color: AppColors.textPrimary),
                ),
                Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 10)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(80, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: AppTextStyles.tagline.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
