import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/dashboard_notifier.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});
