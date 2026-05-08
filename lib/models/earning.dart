import 'package:flutter/foundation.dart';

enum EarningStatus {
  paid,
  pending;

  String get label {
    switch (this) {
      case EarningStatus.paid:
        return 'Paid';
      case EarningStatus.pending:
        return 'Pending';
    }
  }
}

@immutable
class Earning {
  final String id;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double totalAmount;
  final EarningStatus status;
  final List<String> bookingIds;

  const Earning({
    required this.id,
    required this.periodStart,
    required this.periodEnd,
    required this.totalAmount,
    required this.status,
    required this.bookingIds,
  });

  Earning copyWith({
    String? id,
    DateTime? periodStart,
    DateTime? periodEnd,
    double? totalAmount,
    EarningStatus? status,
    List<String>? bookingIds,
  }) {
    return Earning(
      id: id ?? this.id,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      bookingIds: bookingIds ?? this.bookingIds,
    );
  }
}
