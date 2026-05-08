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
    final associatedBookings = allBookings.where((b) => earning.bookingIds.contains(b.id)).toList();
    
    final dateFormat = DateFormat('MMM yyyy');
    final period = '${dateFormat.format(earning.periodStart)} - ${dateFormat.format(earning.periodEnd)}';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Statement Details',
        subtitle: earning.id,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Header
            _buildStatementHeader(period),
            const SizedBox(height: 32),
            
            Text('ORDER BREAKDOWN', style: AppTextStyles.tagline.copyWith(fontSize: 10, color: AppColors.textTertiary)),
            const SizedBox(height: 16),
            
            if (associatedBookings.isEmpty)
              _buildNoBookingsState()
            else
              ...associatedBookings.map((booking) => _buildBookingBreakdownCard(booking)),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementHeader(String period) {
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
                  Text('PAYMENT PERIOD', style: AppTextStyles.tagline.copyWith(color: Colors.white.withAlpha(180))),
                  Text(period, style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 18)),
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
          const Divider(color: Colors.white24),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Payout', style: AppTextStyles.header.copyWith(color: Colors.white, fontSize: 16)),
              Text('₹${earning.totalAmount.toStringAsFixed(2)}', style: AppTextStyles.header.copyWith(color: Colors.white, fontSize: 28)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingBreakdownCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(booking.id, style: AppTextStyles.cardTitle.copyWith(color: AppColors.primaryAccent)),
              Text(
                '₹${booking.totalPrice.toStringAsFixed(0)}',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildDetailRow(IconsaxPlusLinear.user, 'Patient', '${booking.patientName} (${booking.age}y)'),
          _buildDetailRow(IconsaxPlusLinear.receipt_2_1, 'Tests', booking.testsBooked.join(', ')),
          _buildDetailRow(IconsaxPlusLinear.calendar_1, 'Booked on', DateFormat('dd MMM yyyy').format(booking.bookingDate)),
          if (booking.sampleCollectedAt != null)
            _buildDetailRow(IconsaxPlusLinear.glass_1, 'Collected on', DateFormat('dd MMM yyyy').format(booking.sampleCollectedAt!)),
          if (booking.reportDeliveredAt != null)
            _buildDetailRow(IconsaxPlusLinear.document_text_1, 'Delivered on', DateFormat('dd MMM yyyy').format(booking.reportDeliveredAt!)),
          _buildDetailRow(IconsaxPlusLinear.location, 'Address', booking.address),
          _buildDetailRow(IconsaxPlusLinear.call, 'Contact', booking.phone),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColors.textTertiary),
          const SizedBox(width: 8),
          Text('$label: ', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: AppTextStyles.caption)),
        ],
      ),
    );
  }

  Widget _buildNoBookingsState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text('No order breakdown available for this statement.'),
      ),
    );
  }
}
