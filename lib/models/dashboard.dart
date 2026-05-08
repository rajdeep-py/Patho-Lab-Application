import 'package:flutter/foundation.dart';

@immutable
class DashboardData {
  final int totalTests;
  final int pendingBookings;
  final int sampleCollected;
  final int reportsDelivered;
  final List<double> monthlyBookings;
  final List<double> monthlyEarnings;

  const DashboardData({
    required this.totalTests,
    required this.pendingBookings,
    required this.sampleCollected,
    required this.reportsDelivered,
    required this.monthlyBookings,
    required this.monthlyEarnings,
  });

  DashboardData copyWith({
    int? totalTests,
    int? pendingBookings,
    int? sampleCollected,
    int? reportsDelivered,
    List<double>? monthlyBookings,
    List<double>? monthlyEarnings,
  }) {
    return DashboardData(
      totalTests: totalTests ?? this.totalTests,
      pendingBookings: pendingBookings ?? this.pendingBookings,
      sampleCollected: sampleCollected ?? this.sampleCollected,
      reportsDelivered: reportsDelivered ?? this.reportsDelivered,
      monthlyBookings: monthlyBookings ?? this.monthlyBookings,
      monthlyEarnings: monthlyEarnings ?? this.monthlyEarnings,
    );
  }
}
