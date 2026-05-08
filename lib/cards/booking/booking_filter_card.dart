import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';

class BookingFilterCard extends ConsumerStatefulWidget {
  const BookingFilterCard({super.key});

  @override
  ConsumerState<BookingFilterCard> createState() => _BookingFilterCardState();
}

class _BookingFilterCardState extends ConsumerState<BookingFilterCard> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(IconsaxPlusLinear.calendar_search, color: AppColors.primaryAccent, size: 20),
              const SizedBox(width: 12),
              Text('Filter Bookings', style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _rangeStart = null;
                    _rangeEnd = null;
                  });
                  ref.read(bookingProvider.notifier).setDateRange(null, null);
                  ref.read(bookingProvider.notifier).setStatusFilter(null);
                },
                icon: const Icon(IconsaxPlusLinear.refresh, size: 14),
                label: const Text('Reset', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const Divider(height: 24),
          
          // Status Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StatusFilterChip(
                  label: 'All',
                  isSelected: bookingState.statusFilter == null,
                  onTap: () => ref.read(bookingProvider.notifier).setStatusFilter(null),
                ),
                ...BookingStatus.values.map((status) => _StatusFilterChip(
                  label: status.label,
                  isSelected: bookingState.statusFilter == status,
                  onTap: () => ref.read(bookingProvider.notifier).setStatusFilter(status),
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Date Range Summary
          InkWell(
            onTap: () => _showCalendarDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider.withAlpha(100)),
              ),
              child: Row(
                children: [
                  const Icon(IconsaxPlusLinear.calendar_1, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _rangeStart == null 
                          ? 'Select Date Range' 
                          : '${DateFormat('dd MMM').format(_rangeStart!)} - ${_rangeEnd != null ? DateFormat('dd MMM').format(_rangeEnd!) : '...'}',
                      style: AppTextStyles.caption.copyWith(
                        color: _rangeStart == null ? AppColors.textTertiary : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(IconsaxPlusLinear.arrow_down_1, size: 16, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  onRangeSelected: (start, end, focusedDay) {
                    setDialogState(() {
                      _selectedDay = null;
                      _focusedDay = focusedDay;
                      _rangeStart = start;
                      _rangeEnd = end;
                      _rangeSelectionMode = RangeSelectionMode.toggledOn;
                    });
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setDialogState(() => _calendarFormat = format);
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: AppTextStyles.cardTitle,
                    leftChevronIcon: const Icon(IconsaxPlusLinear.arrow_left_2, color: AppColors.primaryAccent),
                    rightChevronIcon: const Icon(IconsaxPlusLinear.arrow_right_3, color: AppColors.primaryAccent),
                  ),
                  calendarStyle: CalendarStyle(
                    rangeStartDecoration: const BoxDecoration(color: AppColors.primaryAccent, shape: BoxShape.circle),
                    rangeEndDecoration: const BoxDecoration(color: AppColors.primaryAccent, shape: BoxShape.circle),
                    rangeHighlightColor: AppColors.primaryAccent.withAlpha(50),
                    todayDecoration: BoxDecoration(color: AppColors.primary.withAlpha(50), shape: BoxShape.circle),
                    todayTextStyle: const TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(bookingProvider.notifier).setDateRange(_rangeStart, _rangeEnd);
                        setState(() {}); // Update the summary in the main card
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          fontSize: 12,
          fontFamily: 'Lexend',
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        backgroundColor: AppColors.background,
        selectedColor: AppColors.primaryAccent,
        checkmarkColor: Colors.white,
        side: BorderSide(color: isSelected ? Colors.transparent : AppColors.divider),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
