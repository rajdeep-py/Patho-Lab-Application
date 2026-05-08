import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../models/earning.dart';
import '../../theme/app_theme.dart';

class EarningCard extends StatelessWidget {
  final Earning earning;

  const EarningCard({super.key, required this.earning});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM yyyy');
    final period = '${dateFormat.format(earning.periodStart)} - ${dateFormat.format(earning.periodEnd)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppCardStyles.sleekCard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/earning-details', extra: earning),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon/Status Badge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: earning.status == EarningStatus.paid 
                        ? AppColors.success.withAlpha(20) 
                        : AppColors.warning.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    earning.status == EarningStatus.paid ? IconsaxPlusBold.wallet_check : IconsaxPlusLinear.wallet_search,
                    color: earning.status == EarningStatus.paid ? AppColors.success : AppColors.warning,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        earning.id,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        period,
                        style: AppTextStyles.caption.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${earning.totalAmount.toStringAsFixed(0)}',
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 18,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StatusTag(status: earning.status),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(IconsaxPlusLinear.arrow_right_3, size: 16, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final EarningStatus status;

  const _StatusTag({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == EarningStatus.paid ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: AppTextStyles.tagline.copyWith(
          fontSize: 8,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
