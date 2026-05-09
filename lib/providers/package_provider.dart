import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/package.dart';
import '../notifiers/package_notifier.dart';

final packageProvider =
    StateNotifierProvider<PackageNotifier, List<LabPackage>>((ref) {
      return PackageNotifier();
    });

final packageSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredPackagesProvider = Provider<List<LabPackage>>((ref) {
  final packages = ref.watch(packageProvider);
  final searchQuery = ref.watch(packageSearchQueryProvider).toLowerCase();

  return packages.where((package) {
    return package.name.toLowerCase().contains(searchQuery) ||
        package.description.toLowerCase().contains(searchQuery);
  }).toList();
});
