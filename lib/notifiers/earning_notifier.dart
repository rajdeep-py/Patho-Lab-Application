import 'package:flutter_riverpod/legacy.dart';
import '../models/earning.dart';

class EarningState {
  final List<Earning> earnings;
  final bool isLoading;
  final int? yearFilter;
  final int? monthFilter;

  EarningState({
    required this.earnings,
    this.isLoading = false,
    this.yearFilter,
    this.monthFilter,
  });

  EarningState copyWith({
    List<Earning>? earnings,
    bool? isLoading,
    int? yearFilter,
    int? monthFilter,
  }) {
    return EarningState(
      earnings: earnings ?? this.earnings,
      isLoading: isLoading ?? this.isLoading,
      yearFilter: yearFilter ?? this.yearFilter,
      monthFilter: monthFilter ?? this.monthFilter,
    );
  }
}

class EarningNotifier extends StateNotifier<EarningState> {
  EarningNotifier()
    : super(
        EarningState(
          earnings: [],
          yearFilter: DateTime.now().year,
          monthFilter: DateTime.now().month,
        ),
      ) {
    _loadDummyData();
  }

  void _loadDummyData() {
    final dummyEarnings = [
      Earning(
        id: 'PAY-2024-001',
        periodStart: DateTime(2024, 1, 1),
        periodEnd: DateTime(2024, 1, 31),
        totalAmount: 45000,
        status: EarningStatus.paid,
        bookingIds: ['BK-1001', 'BK-1002', 'BK-1003'],
      ),
      Earning(
        id: 'PAY-2024-002',
        periodStart: DateTime(2024, 2, 1),
        periodEnd: DateTime(2024, 2, 28),
        totalAmount: 52000,
        status: EarningStatus.paid,
        bookingIds: ['BK-1004', 'BK-1005'],
      ),
      Earning(
        id: 'PAY-2024-003',
        periodStart: DateTime(2024, 3, 1),
        periodEnd: DateTime(2024, 3, 31),
        totalAmount: 12500,
        status: EarningStatus.pending,
        bookingIds: ['BK-1006'],
      ),
    ];
    state = state.copyWith(earnings: dummyEarnings);
  }

  void setFilters({int? year, int? month}) {
    state = state.copyWith(yearFilter: year, monthFilter: month);
  }
}
