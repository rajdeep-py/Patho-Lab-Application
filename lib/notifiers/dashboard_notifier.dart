import 'package:flutter_riverpod/legacy.dart';
import '../models/dashboard.dart';

class DashboardState {
  final DashboardData? data;
  final bool isLoading;

  DashboardState({
    this.data,
    this.isLoading = false,
  });

  DashboardState copyWith({
    DashboardData? data,
    bool? isLoading,
  }) {
    return DashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    final dummyData = DashboardData(
      totalTests: 124,
      pendingBookings: 18,
      sampleCollected: 42,
      reportsDelivered: 156,
      monthlyBookings: [30, 45, 35, 50, 65, 55, 70, 85, 80, 95, 110, 100],
      monthlyEarnings: [12000, 15000, 14000, 18000, 22000, 20000, 25000, 28000, 27000, 32000, 35000, 33000],
    );

    state = state.copyWith(data: dummyData, isLoading: false);
  }
}
