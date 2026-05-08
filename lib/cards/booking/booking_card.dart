import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../models/booking.dart';
import '../../theme/app_theme.dart';
import 'booking_details_bottomsheet.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppCardStyles.sleekCard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetails(context),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        booking.id,
                        style: AppTextStyles.tagline.copyWith(fontSize: 10, color: AppColors.primaryAccent),
                      ),
                    ),
                    _StatusIndicator(status: booking.status),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  booking.testsBooked.join(', '),
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 16, height: 1.2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(IconsaxPlusLinear.calendar_1, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(booking.bookingDate),
                      style: AppTextStyles.caption.copyWith(fontSize: 12),
                    ),
                    const Spacer(),
                    const Icon(IconsaxPlusLinear.arrow_right_3, size: 16, color: AppColors.textTertiary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingDetailsBottomSheet(booking: booking),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final BookingStatus status;

  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case BookingStatus.pending:
        color = AppColors.warning;
      case BookingStatus.sampleCollected:
        color = AppColors.info;
      case BookingStatus.reportDelivered:
        color = AppColors.success;
      case BookingStatus.cancelled:
        color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.label.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
