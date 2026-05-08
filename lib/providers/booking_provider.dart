import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/booking_notifier.dart';

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((
  ref,
) {
  return BookingNotifier();
});
