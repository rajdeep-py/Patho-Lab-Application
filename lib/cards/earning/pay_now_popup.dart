import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import 'payment_card.dart';

class PayNowPopup extends StatefulWidget {
  final double totalDue;

  const PayNowPopup({super.key, required this.totalDue});

  @override
  State<PayNowPopup> createState() => _PayNowPopupState();
}

class _PayNowPopupState extends State<PayNowPopup> {
  bool _isInstallment = false;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.totalDue.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Settlement Payment', style: AppTextStyles.subHeader.copyWith(fontSize: 20)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(IconsaxPlusLinear.close_circle, color: AppColors.textTertiary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total Outstanding: ₹${widget.totalDue.toStringAsFixed(2)}',
              style: AppTextStyles.tagline.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 24),
            
            // Payment Options
            Row(
              children: [
                Expanded(
                  child: _OptionCard(
                    title: 'Full Due',
                    isSelected: !_isInstallment,
                    onTap: () {
                      setState(() {
                        _isInstallment = false;
                        _amountController.text = widget.totalDue.toStringAsFixed(2);
                      });
                    },
                    icon: IconsaxPlusLinear.wallet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OptionCard(
                    title: 'Installment',
                    isSelected: _isInstallment,
                    onTap: () {
                      setState(() {
                        _isInstallment = true;
                        _amountController.clear();
                      });
                    },
                    icon: IconsaxPlusLinear.card_add,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Amount Input
            Text(
              _isInstallment ? 'Enter Installment Amount' : 'Total Amount to Pay',
              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              readOnly: !_isInstallment,
              decoration: InputDecoration(
                prefixText: '₹ ',
                hintText: '0.00',
                suffixIcon: _isInstallment ? const Icon(IconsaxPlusLinear.edit, size: 18) : null,
              ),
              style: AppTextStyles.cardTitle.copyWith(color: AppColors.primaryAccent),
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(_amountController.text) ?? widget.totalDue;
                  Navigator.pop(context); // Close current popup
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(amount: amount),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('PAY NOW'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  const _OptionCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent.withAlpha(20) : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryAccent : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showPayNowPopup(BuildContext context, double totalDue) {
  showDialog(
    context: context,
    builder: (context) => PayNowPopup(totalDue: totalDue),
  );
}
