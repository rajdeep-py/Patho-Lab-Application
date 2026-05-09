import 'package:flutter_riverpod/legacy.dart';
import '../models/earning.dart';

class EarningState {
  final List<Earning> earnings;
  final bool isLoading;
  final int? yearFilter;
  final int? monthFilter;
  final bool isClaimPending;

  EarningState({
    required this.earnings,
    this.isLoading = false,
    this.yearFilter,
    this.monthFilter,
    this.isClaimPending = false,
  });

  double get totalToBePaid => earnings
      .where((e) => e.type == EarningType.toBePaid)
      .fold(0, (sum, e) => sum + e.orderAmount);

  double get totalToBeClaimed => earnings
      .where((e) => e.type == EarningType.toBeClaimed)
      .fold(0, (sum, e) => sum + e.orderAmount);

  EarningState copyWith({
    List<Earning>? earnings,
    bool? isLoading,
    int? yearFilter,
    int? monthFilter,
    bool? isClaimPending,
  }) {
    return EarningState(
      earnings: earnings ?? this.earnings,
      isLoading: isLoading ?? this.isLoading,
      yearFilter: yearFilter ?? this.yearFilter,
      monthFilter: monthFilter ?? this.monthFilter,
      isClaimPending: isClaimPending ?? this.isClaimPending,
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
    final now = DateTime.now();
    final dummyEarnings = [
      _createEarning(
        'PAY-001',
        'BK-1001',
        1500,
        EarningStatus.paid,
        EarningType.toBePaid,
        now.subtract(const Duration(days: 2)),
        'John Doe',
        'Complete Blood Count',
      ),
      _createEarning(
        'PAY-002',
        'BK-1002',
        2500,
        EarningStatus.paid,
        EarningType.toBeClaimed,
        now.subtract(const Duration(days: 5)),
        'Jane Smith',
        'Lipid Profile',
      ),
      _createEarning(
        'PAY-003',
        'BK-1003',
        1200,
        EarningStatus.pending,
        EarningType.toBePaid,
        now.subtract(const Duration(days: 1)),
        'Robert Brown',
        'Thyroid Test',
      ),
      _createEarning(
        'PAY-004',
        'BK-1004',
        3500,
        EarningStatus.paid,
        EarningType.toBeClaimed,
        now.subtract(const Duration(days: 10)),
        'Alice Johnson',
        'Diabetes Screen',
      ),
      _createEarning(
        'PAY-005',
        'BK-1005',
        800,
        EarningStatus.pending,
        EarningType.toBePaid,
        now,
        'Michael Wilson',
        'Urine Analysis',
      ),
    ];
    state = state.copyWith(earnings: dummyEarnings);
  }

  Earning _createEarning(
    String id,
    String bookingId,
    double amount,
    EarningStatus status,
    EarningType type,
    DateTime date,
    String customerName,
    String serviceName,
  ) {
    const commissionRate = 0.15; // 15% commission
    final commission = amount * commissionRate;
    return Earning(
      id: id,
      bookingId: bookingId,
      orderAmount: amount,
      commissionAmount: commission,
      netAmount: amount - commission,
      status: status,
      type: type,
      date: date,
      customerName: customerName,
      serviceName: serviceName,
    );
  }

  void setFilters({int? year, int? month}) {
    state = state.copyWith(yearFilter: year, monthFilter: month);
  }

  void submitClaim() {
    state = state.copyWith(isClaimPending: true);
  }
}
