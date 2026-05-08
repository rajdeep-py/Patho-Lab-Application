import 'package:flutter_riverpod/legacy.dart';
import '../models/booking.dart';

class BookingState {
  final List<Booking> bookings;
  final bool isLoading;
  final DateTime? startDate;
  final DateTime? endDate;
  final BookingStatus? statusFilter;

  BookingState({
    required this.bookings,
    this.isLoading = false,
    this.startDate,
    this.endDate,
    this.statusFilter,
  });

  BookingState copyWith({
    List<Booking>? bookings,
    bool? isLoading,
    DateTime? startDate,
    DateTime? endDate,
    BookingStatus? statusFilter,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(BookingState(bookings: [])) {
    _loadDummyData();
  }

  void _loadDummyData() {
    final now = DateTime.now();
    final dummyBookings = [
      Booking(
        id: 'BK-1001',
        bookingDate: now.subtract(const Duration(days: 1)),
        patientName: 'Rajesh Kumar',
        age: 45,
        phone: '9876543210',
        email: 'rajesh.k@example.com',
        address: '123, Green Park, South Delhi, 110016',
        testsBooked: ['Complete Blood Count (CBC)', 'Thyroid Profile'],
        status: BookingStatus.pending,
        totalPrice: 1250,
      ),
      Booking(
        id: 'BK-1002',
        bookingDate: now.subtract(const Duration(days: 2)),
        patientName: 'Anita Sharma',
        age: 32,
        phone: '9123456789',
        alternativePhone: '9988776655',
        email: 'anita.s@example.com',
        address: 'A-45, HSR Layout, Bangalore, 560102',
        testsBooked: ['Liver Function Test (LFT)'],
        sampleCollectedAt: now.subtract(const Duration(days: 1)),
        status: BookingStatus.sampleCollected,
        totalPrice: 800,
      ),
      Booking(
        id: 'BK-1003',
        bookingDate: now.subtract(const Duration(days: 5)),
        patientName: 'Suresh Raina',
        age: 38,
        phone: '8877665544',
        email: 'suresh.r@example.com',
        address: 'Tower 4, Sea Breeze Apts, Mumbai, 400001',
        testsBooked: ['Lipid Profile', 'HbA1c'],
        sampleCollectedAt: now.subtract(const Duration(days: 4)),
        reportDeliveredAt: now.subtract(const Duration(days: 3)),
        status: BookingStatus.reportDelivered,
        totalPrice: 1500,
      ),
    ];
    state = state.copyWith(bookings: dummyBookings);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setStatusFilter(BookingStatus? status) {
    state = state.copyWith(statusFilter: status);
  }

  void updateBookingStatus(String id, BookingStatus newStatus) {
    final now = DateTime.now();
    final updatedBookings = state.bookings.map((booking) {
      if (booking.id == id) {
        return booking.copyWith(
          status: newStatus,
          sampleCollectedAt: newStatus == BookingStatus.sampleCollected
              ? now
              : booking.sampleCollectedAt,
          reportDeliveredAt: newStatus == BookingStatus.reportDelivered
              ? now
              : booking.reportDeliveredAt,
        );
      }
      return booking;
    }).toList();
    state = state.copyWith(bookings: updatedBookings);
  }
}
