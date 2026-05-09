import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/test.dart';
import '../notifiers/test_notifier.dart';

final testProvider = StateNotifierProvider<TestNotifier, List<LabTest>>((ref) {
  return TestNotifier();
});

final testSearchQueryProvider = StateProvider<String>((ref) => '');
final testCategoryFilterProvider = StateProvider<String>((ref) => 'All');

final filteredTestsProvider = Provider<List<LabTest>>((ref) {
  final tests = ref.watch(testProvider);
  final query = ref.watch(testSearchQueryProvider).toLowerCase();
  final category = ref.watch(testCategoryFilterProvider);

  return tests.where((test) {
    final matchesQuery = test.name.toLowerCase().contains(query);
    final matchesCategory = category == 'All' || test.category == category;
    return matchesQuery && matchesCategory;
  }).toList();
});
