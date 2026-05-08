import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/earning_notifier.dart';

final earningProvider = StateNotifierProvider<EarningNotifier, EarningState>((ref) {
  return EarningNotifier();
});
