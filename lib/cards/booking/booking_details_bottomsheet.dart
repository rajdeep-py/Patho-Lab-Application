import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../models/booking.dart';
import '../../theme/app_theme.dart';
import '../../providers/booking_provider.dart';

class BookingDetailsBottomSheet extends ConsumerWidget {
  final Booking booking;

  const BookingDetailsBottomSheet({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(IconsaxPlusLinear.document_text_1, color: AppColors.primaryAccent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.id, style: AppTextStyles.cardTitle),
                      Text(
                        'Booked on ${DateFormat('dd MMM yyyy').format(booking.bookingDate)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(IconsaxPlusLinear.close_circle),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('Patient Information', [
                    _InfoRow(label: 'Name', value: booking.patientName, icon: IconsaxPlusLinear.user),
                    _InfoRow(label: 'Age', value: '${booking.age} Years', icon: IconsaxPlusLinear.cake),
                    _InfoRow(label: 'Phone', value: booking.phone, icon: IconsaxPlusLinear.call),
                    if (booking.alternativePhone != null)
                      _InfoRow(label: 'Alt Phone', value: booking.alternativePhone!, icon: IconsaxPlusLinear.call_calling),
                    _InfoRow(label: 'Email', value: booking.email, icon: IconsaxPlusLinear.sms),
                  ]),
                  
                  const SizedBox(height: 24),
                  
                  _buildSection('Booking Details', [
                    _InfoRow(label: 'Tests Booked', value: booking.testsBooked.join(', '), icon: IconsaxPlusLinear.receipt_2_1),
                    _InfoRow(label: 'Collection Address', value: booking.address, icon: IconsaxPlusLinear.location),
                    if (booking.sampleCollectedAt != null)
                      _InfoRow(
                        label: 'Sample Collected At',
                        value: DateFormat('dd MMM yyyy, hh:mm a').format(booking.sampleCollectedAt!),
                        icon: IconsaxPlusLinear.glass_1,
                      ),
                    if (booking.reportDeliveredAt != null)
                      _InfoRow(
                        label: 'Report Delivered At',
                        value: DateFormat('dd MMM yyyy, hh:mm a').format(booking.reportDeliveredAt!),
                        icon: IconsaxPlusLinear.document_text_1,
                      ),
                  ]),
                  
                  const SizedBox(height: 32),
                  
                  Text('Update Status', style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
                  const SizedBox(height: 16),
                  
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.5,
                    children: BookingStatus.values.map((status) {
                      final isCurrent = booking.status == status;
                      return InkWell(
                        onTap: () {
                          ref.read(bookingProvider.notifier).updateBookingStatus(booking.id, status);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Status updated to ${status.label}'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isCurrent ? AppColors.primaryAccent : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCurrent ? Colors.transparent : AppColors.divider,
                            ),
                            boxShadow: isCurrent ? [
                              BoxShadow(
                                color: AppColors.primaryAccent.withAlpha(60),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ] : [],
                          ),
                          child: Center(
                            child: Text(
                              status.label,
                              style: AppTextStyles.caption.copyWith(
                                color: isCurrent ? Colors.white : AppColors.textSecondary,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: AppTextStyles.tagline.copyWith(fontSize: 10, color: AppColors.textTertiary)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppCardStyles.sleekCard,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
                Text(value, style: AppTextStyles.description.copyWith(fontSize: 14, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
