import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/test_notifier.dart';

final testProvider = StateNotifierProvider<TestNotifier, TestState>((ref) {
  return TestNotifier();
});
