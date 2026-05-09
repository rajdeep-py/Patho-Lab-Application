import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../models/earning.dart';
import '../../models/booking.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/booking_provider.dart';

class EarningDetailsScreen extends ConsumerWidget {
  final Earning earning;

  const EarningDetailsScreen({super.key, required this.earning});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBookings = ref.watch(bookingProvider).bookings;
    final booking = allBookings.firstWhere(
      (b) => b.id == earning.bookingId,
      orElse: () => _emptyBooking(earning.bookingId),
    );

    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final dateStr = dateFormat.format(earning.date);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Transaction Details',
        subtitle: 'ID: ${earning.id}',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Header
            _buildEarningSummaryCard(dateStr),
            const SizedBox(height: 32),

            Text(
              'PAYMENT BREAKDOWN',
              style: AppTextStyles.tagline.copyWith(fontSize: 10, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 16),
            _buildBreakdownDetails(),

            const SizedBox(height: 32),
            Text(
              'ORDER INFORMATION',
              style: AppTextStyles.tagline.copyWith(fontSize: 10, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 16),
            _buildBookingBreakdownCard(booking),

            const SizedBox(height: 40),
            _buildActionButtons(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningSummaryCard(String dateStr) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppCardStyles.primaryGradientCard,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TRANSACTION DATE',
                    style: AppTextStyles.tagline.copyWith(color: Colors.white.withAlpha(180), fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  earning.status.label.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NET EARNING',
                    style: AppTextStyles.tagline.copyWith(color: Colors.white.withAlpha(180), fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${earning.netAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.header.copyWith(color: Colors.white, fontSize: 32),
                  ),
                ],
              ),
              Icon(
                earning.type == EarningType.toBePaid ? IconsaxPlusBold.wallet_add : IconsaxPlusBold.wallet_check,
                color: Colors.white.withAlpha(100),
                size: 48,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        children: [
          _buildBreakdownRow('Total Order Amount', '₹${earning.orderAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildBreakdownRow('Platform Commission (15%)', '- ₹${earning.commissionAmount.toStringAsFixed(2)}', isNegative: true),
          const SizedBox(height: 12),
          _buildBreakdownRow('TDS / Other Deductions', '- ₹0.00', isNegative: true),
          const Divider(height: 32),
          _buildBreakdownRow('Settlement Amount', '₹${earning.netAmount.toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, {bool isNegative = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.description.copyWith(fontSize: 14)),
        Text(
          value,
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 16,
            color: isNegative ? AppColors.error : (isBold ? AppColors.primaryAccent : AppColors.textPrimary),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingBreakdownCard(Booking booking) {
    final displayCustomer = earning.customerName ?? booking.patientName;
    final displayService = earning.serviceName ?? (booking.testsBooked.isNotEmpty ? booking.testsBooked.join(', ') : 'Medical Service');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking: ${booking.id}',
                style: AppTextStyles.cardTitle.copyWith(color: AppColors.primaryAccent, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.info.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  earning.type.label.toUpperCase(),
                  style: AppTextStyles.tagline.copyWith(fontSize: 8, color: AppColors.info),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildDetailRow(IconsaxPlusLinear.user, 'Customer', displayCustomer),
          _buildDetailRow(IconsaxPlusLinear.receipt_2_1, 'Service', displayService),
          _buildDetailRow(IconsaxPlusLinear.wallet_2, 'Payment Mode', earning.type == EarningType.toBePaid ? 'Cash on Delivery' : 'Online Payment'),
          _buildDetailRow(IconsaxPlusLinear.location, 'Location', booking.address.isNotEmpty ? booking.address : 'Lab Visit'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 10)),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.description.copyWith(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(IconsaxPlusLinear.document_download),
            label: const Text('Invoice'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primaryAccent),
              foregroundColor: AppColors.primaryAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(IconsaxPlusLinear.message_question),
            label: const Text('Support'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primaryAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }

  Booking _emptyBooking(String id) {
    return Booking(
      id: id,
      bookingDate: DateTime.now(),
      patientName: 'Unknown Patient',
      age: 0,
      phone: '',
      email: '',
      address: 'N/A',
      testsBooked: [],
      status: BookingStatus.pending,
      totalPrice: 0,
    );
  }
}
