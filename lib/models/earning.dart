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

enum EarningType {
  toBePaid,   // Collected during sample collection or report delivery
  toBeClaimed; // Paid via online

  String get label {
    switch (this) {
      case EarningType.toBePaid:
        return 'To be Paid';
      case EarningType.toBeClaimed:
        return 'To be Claimed';
    }
  }
}

@immutable
class Earning {
  final String id;
  final String bookingId;
  final double orderAmount;
  final double commissionAmount;
  final double netAmount;
  final EarningStatus status;
  final EarningType type;
  final DateTime date;
  final String? customerName;
  final String? serviceName;

  const Earning({
    required this.id,
    required this.bookingId,
    required this.orderAmount,
    required this.commissionAmount,
    required this.netAmount,
    required this.status,
    required this.type,
    required this.date,
    this.customerName,
    this.serviceName,
  });

  Earning copyWith({
    String? id,
    String? bookingId,
    double? orderAmount,
    double? commissionAmount,
    double? netAmount,
    EarningStatus? status,
    EarningType? type,
    DateTime? date,
    String? customerName,
    String? serviceName,
  }) {
    return Earning(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      orderAmount: orderAmount ?? this.orderAmount,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      netAmount: netAmount ?? this.netAmount,
      status: status ?? this.status,
      type: type ?? this.type,
      date: date ?? this.date,
      customerName: customerName ?? this.customerName,
      serviceName: serviceName ?? this.serviceName,
    );
  }
}
