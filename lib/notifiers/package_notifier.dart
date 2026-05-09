import 'package:flutter_riverpod/legacy.dart';
import '../models/package.dart';

class PackageNotifier extends StateNotifier<List<LabPackage>> {
  PackageNotifier() : super(_initialPackages);

  void addPackage(LabPackage package) {
    state = [...state, package];
  }

  void updatePackage(LabPackage package) {
    state = [
      for (final p in state)
        if (p.id == package.id) package else p,
    ];
  }

  void deletePackage(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  static final List<LabPackage> _initialPackages = [
    LabPackage(
      id: 'pkg-1',
      name: 'Comprehensive Full Body Checkup',
      price: 2999.0,
      description:
          'A complete full body health checkup package covering multiple parameters for a thorough health assessment.',
      labTestIds: [
        '1',
        '2',
      ], // Assuming these IDs map to default tests in TestProvider
      sampleCollectionTime: '60 mins',
      reportDeliveryTime: '24 Hours',
      photoUrl:
          'https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=2070&auto=format&fit=crop',
    ),
  ];
}
