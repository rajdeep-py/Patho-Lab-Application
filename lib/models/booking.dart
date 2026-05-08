import 'package:flutter/foundation.dart';

enum BookingStatus {
  pending,
  sampleCollected,
  reportDelivered,
  cancelled;

  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.sampleCollected:
        return 'Sample Collected';
      case BookingStatus.reportDelivered:
        return 'Report Delivered';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

@immutable
class Booking {
  final String id;
  final DateTime bookingDate;
  final String patientName;
  final int age;
  final String phone;
  final String? alternativePhone;
  final String email;
  final String address;
  final List<String> testsBooked;
  final DateTime? sampleCollectedAt;
  final DateTime? reportDeliveredAt;
  final BookingStatus status;
  final double totalPrice;

  const Booking({
    required this.id,
    required this.bookingDate,
    required this.patientName,
    required this.age,
    required this.phone,
    this.alternativePhone,
    required this.email,
    required this.address,
    required this.testsBooked,
    this.sampleCollectedAt,
    this.reportDeliveredAt,
    required this.status,
    required this.totalPrice,
  });

  Booking copyWith({
    String? id,
    DateTime? bookingDate,
    String? patientName,
    int? age,
    String? phone,
    String? alternativePhone,
    String? email,
    String? address,
    List<String>? testsBooked,
    DateTime? sampleCollectedAt,
    DateTime? reportDeliveredAt,
    BookingStatus? status,
    double? totalPrice,
  }) {
    return Booking(
      id: id ?? this.id,
      bookingDate: bookingDate ?? this.bookingDate,
      patientName: patientName ?? this.patientName,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      alternativePhone: alternativePhone ?? this.alternativePhone,
      email: email ?? this.email,
      address: address ?? this.address,
      testsBooked: testsBooked ?? this.testsBooked,
      sampleCollectedAt: sampleCollectedAt ?? this.sampleCollectedAt,
      reportDeliveredAt: reportDeliveredAt ?? this.reportDeliveredAt,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
