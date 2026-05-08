import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/booking_provider.dart';
import '../../cards/booking/booking_filter_card.dart';
import '../../cards/booking/booking_card.dart';

class BookingManagementScreen extends ConsumerWidget {
  const BookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final filteredBookings = bookingState.bookings.where((booking) {
      bool matchesDate = true;
      if (bookingState.startDate != null && bookingState.endDate != null) {
        matchesDate = booking.bookingDate.isAfter(bookingState.startDate!) &&
            booking.bookingDate.isBefore(bookingState.endDate!.add(const Duration(days: 1)));
      }

      bool matchesStatus = true;
      if (bookingState.statusFilter != null) {
        matchesStatus = booking.status == bookingState.statusFilter;
      }

      return matchesDate && matchesStatus;
    }).toList();

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: const CustomAppBar(
        title: 'Test Bookings',
        subtitle: 'Manage appointments and results',
        showMenuButton: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // In a real app, this would refresh from API
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BookingFilterCard(),
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Bookings (${filteredBookings.length})',
                    style: AppTextStyles.subHeader.copyWith(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (filteredBookings.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Opacity(
                        opacity: 0.5,
                        child: Icon(Icons.calendar_today_outlined, size: 64, color: AppColors.textTertiary),
                      ),
                      const SizedBox(height: 16),
                      Text('No bookings found for the selected filters', style: AppTextStyles.description),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    return BookingCard(booking: filteredBookings[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
