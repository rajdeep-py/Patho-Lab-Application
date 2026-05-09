import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';

class CompanyEarningCard extends StatefulWidget {
  final String transactionId;
  final double amount;
  final bool isCredit; // true for credited, false for debited
  final DateTime date;
  final Map<String, double> breakdown;

  const CompanyEarningCard({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.isCredit,
    required this.date,
    required this.breakdown,
  });

  @override
  State<CompanyEarningCard> createState() => _CompanyEarningCardState();
}

class _CompanyEarningCardState extends State<CompanyEarningCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final color = widget.isCredit ? AppColors.success : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isCredit ? IconsaxPlusLinear.arrow_down_1 : IconsaxPlusLinear.arrow_up_3,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${widget.transactionId}',
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormat.format(widget.date),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.isCredit ? '+' : '-'} ₹${widget.amount.toStringAsFixed(2)}',
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 18,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StatusTag(isCredit: widget.isCredit),
                  ],
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BREAKDOWN', style: AppTextStyles.tagline.copyWith(fontSize: 10)),
                  const SizedBox(height: 12),
                  ...widget.breakdown.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: AppTextStyles.description.copyWith(fontSize: 12)),
                        Text('₹${e.value.toStringAsFixed(2)}', style: AppTextStyles.cardTitle.copyWith(fontSize: 12)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppSpacing.cardRadius)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background.withAlpha(100),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppSpacing.cardRadius)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isExpanded ? 'VIEW LESS' : 'VIEW DETAILS',
                    style: AppTextStyles.tagline.copyWith(fontSize: 10, color: AppColors.primaryAccent),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded ? IconsaxPlusLinear.arrow_up_1 : IconsaxPlusLinear.arrow_down_1,
                    size: 14,
                    color: AppColors.primaryAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final bool isCredit;

  const _StatusTag({required this.isCredit});

  @override
  Widget build(BuildContext context) {
    final color = isCredit ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isCredit ? 'CREDITED' : 'DEBITED',
        style: AppTextStyles.tagline.copyWith(
          fontSize: 8,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
