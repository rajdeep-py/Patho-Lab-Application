import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/earning_notifier.dart';

/// Provider for the EarningNotifier and its state.
final earningProvider = StateNotifierProvider<EarningNotifier, EarningState>((
  ref,
) {
  return EarningNotifier();
});
