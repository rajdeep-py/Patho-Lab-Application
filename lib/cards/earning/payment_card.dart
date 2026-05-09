import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';

enum PaymentMethod { creditCard, debitCard, upi }

class PaymentScreen extends StatefulWidget {
  final double amount;

  const PaymentScreen({super.key, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complete Payment'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconsaxPlusLinear.arrow_left_1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 32),
            Text(
              'Select Payment Method',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodSelector(),
            const SizedBox(height: 32),
            _buildPaymentFields(),
            const SizedBox(height: 40),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.sleekCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PAYMENT AMOUNT',
                style: AppTextStyles.tagline.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 4),
              Text(
                'Settlement Dues',
                style: AppTextStyles.description.copyWith(fontSize: 14),
              ),
            ],
          ),
          Text(
            '₹${widget.amount.toStringAsFixed(2)}',
            style: AppTextStyles.header.copyWith(
              fontSize: 24,
              color: AppColors.primaryAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        _PaymentOptionTile(
          title: 'Credit Card',
          method: PaymentMethod.creditCard,
          selectedMethod: _selectedMethod,
          icon: IconsaxPlusLinear.card,
          onTap: () =>
              setState(() => _selectedMethod = PaymentMethod.creditCard),
        ),
        const SizedBox(height: 12),
        _PaymentOptionTile(
          title: 'Debit Card',
          method: PaymentMethod.debitCard,
          selectedMethod: _selectedMethod,
          icon: IconsaxPlusLinear.card_pos,
          onTap: () =>
              setState(() => _selectedMethod = PaymentMethod.debitCard),
        ),
        const SizedBox(height: 12),
        _PaymentOptionTile(
          title: 'UPI / QR Code',
          method: PaymentMethod.upi,
          selectedMethod: _selectedMethod,
          icon: IconsaxPlusLinear.scan_barcode,
          onTap: () => setState(() => _selectedMethod = PaymentMethod.upi),
        ),
      ],
    );
  }

  Widget _buildPaymentFields() {
    if (_selectedMethod == PaymentMethod.upi) {
      return _buildUpiSection();
    }
    return _buildCardSection();
  }

  Widget _buildCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Details',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Card Number',
            prefixIcon: Icon(IconsaxPlusLinear.card, size: 20),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Expiry (MM/YY)',
                  prefixIcon: Icon(IconsaxPlusLinear.calendar_1, size: 20),
                ),
                keyboardType: TextInputType.datetime,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'CVV',
                  prefixIcon: Icon(IconsaxPlusLinear.lock, size: 20),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpiSection() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                Image.network(
                  'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=PathoLabPayment',
                  height: 200,
                  width: 200,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 200,
                      width: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text('Scan to Pay', style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'UPI ID: patholab.admin@upi',
            style: AppTextStyles.tagline.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showSuccessPopup();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Text('PAY ₹${widget.amount.toStringAsFixed(2)}'),
      ),
    );
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                IconsaxPlusBold.tick_circle,
                color: AppColors.success,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text('Payment Successful', style: AppTextStyles.subHeader),
              const SizedBox(height: 12),
              Text(
                'Your payment of ₹${widget.amount.toStringAsFixed(2)} has been processed successfully.',
                textAlign: TextAlign.center,
                style: AppTextStyles.description.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Pop dialog
                    Navigator.of(context).pop(); // Pop payment screen
                  },
                  child: const Text('BACK TO EARNINGS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final String title;
  final PaymentMethod method;
  final PaymentMethod selectedMethod;
  final IconData icon;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.title,
    required this.method,
    required this.selectedMethod,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = method == selectedMethod;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryAccent.withAlpha(15)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryAccent
                  : AppColors.textTertiary,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(
                fontSize: 15,
                color: isSelected
                    ? AppColors.primaryAccent
                    : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                IconsaxPlusBold.tick_circle,
                color: AppColors.primaryAccent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
