import 'package:flutter_riverpod/legacy.dart';
import '../models/test.dart';

class TestState {
  final List<LabTest> inventory;
  final List<LabTest> availableTests;
  final bool isLoading;
  final String? searchQuery;
  final String? categoryFilter;

  TestState({
    required this.inventory,
    required this.availableTests,
    this.isLoading = false,
    this.searchQuery,
    this.categoryFilter,
  });

  TestState copyWith({
    List<LabTest>? inventory,
    List<LabTest>? availableTests,
    bool? isLoading,
    String? searchQuery,
    String? categoryFilter,
  }) {
    return TestState(
      inventory: inventory ?? this.inventory,
      availableTests: availableTests ?? this.availableTests,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilter: categoryFilter ?? this.categoryFilter,
    );
  }
}

class TestNotifier extends StateNotifier<TestState> {
  TestNotifier() : super(TestState(inventory: [], availableTests: [])) {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Dummy data for available tests
    final dummyTests = [
      LabTest(
        id: '1',
        name: 'Complete Blood Count (CBC)',
        category: 'Hematology',
        price: 450,
        photoUrl:
            'https://images.unsplash.com/photo-1579152276503-6119159957d3?q=80&w=2070&auto=format&fit=crop',
        description:
            'A complete blood count (CBC) is a blood test used to evaluate your overall health and detect a wide range of disorders.',
        parameters: ['Hemoglobin', 'WBC Count', 'Platelet Count', 'RBC Count'],
        precautions: 'Overnight fasting is preferred but not mandatory.',
        sampleCollectionFlow:
            'Blood sample is collected from a vein in your arm.',
        deliveryReportFlow: 'Report will be available within 12-24 hours.',
      ),
      LabTest(
        id: '2',
        name: 'Liver Function Test (LFT)',
        category: 'Biochemistry',
        price: 800,
        photoUrl:
            'https://images.unsplash.com/photo-1581594549595-35e6ed96102e?q=80&w=2070&auto=format&fit=crop',
        description:
            'Liver function tests are blood tests used to help diagnose and monitor liver disease or damage.',
        parameters: ['SGOT', 'SGPT', 'Bilirubin Total', 'Albumin'],
        precautions: '10-12 hours fasting is required.',
        sampleCollectionFlow: 'Venous blood collection.',
        deliveryReportFlow: 'Digital report within 8 hours.',
      ),
      LabTest(
        id: '3',
        name: 'Thyroid Profile (T3, T4, TSH)',
        category: 'Endocrinology',
        price: 600,
        photoUrl:
            'https://images.unsplash.com/photo-1614935151651-0bea6508db6b?q=80&w=2070&auto=format&fit=crop',
        description:
            'This test measures the level of thyroid hormones in the blood.',
        parameters: ['Total T3', 'Total T4', 'TSH Ultra-sensitive'],
        precautions: 'No special preparation needed.',
        sampleCollectionFlow: 'Standard blood draw.',
        deliveryReportFlow: 'Next day delivery.',
      ),
      LabTest(
        id: '4',
        name: 'Lipid Profile',
        category: 'Biochemistry',
        price: 750,
        photoUrl:
            'https://images.unsplash.com/photo-1628177142898-93e36e4e3a50?q=80&w=2070&auto=format&fit=crop',
        description:
            'A lipid profile is a panel of blood tests used to find abnormalities in lipids.',
        parameters: ['Cholesterol Total', 'Triglycerides', 'HDL', 'LDL'],
        precautions: 'Mandatory 12 hours fasting.',
        sampleCollectionFlow: 'Blood sample from vein.',
        deliveryReportFlow: 'Report within 24 hours.',
      ),
    ];

    state = state.copyWith(
      availableTests: dummyTests,
      inventory: [dummyTests[0], dummyTests[1]],
    );
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategoryFilter(String? category) {
    state = state.copyWith(categoryFilter: category);
  }

  void toggleTestStatus(String id) {
    final updatedInventory = state.inventory.map((test) {
      if (test.id == id) {
        return test.copyWith(isActive: !test.isActive);
      }
      return test;
    }).toList();
    state = state.copyWith(inventory: updatedInventory);
  }

  void updateTestDetails(
    String id, {
    double? price,
    String? collectionFlow,
    String? deliveryFlow,
  }) {
    final updatedInventory = state.inventory.map((test) {
      if (test.id == id) {
        return test.copyWith(
          price: price ?? test.price,
          sampleCollectionFlow: collectionFlow ?? test.sampleCollectionFlow,
          deliveryReportFlow: deliveryFlow ?? test.deliveryReportFlow,
        );
      }
      return test;
    }).toList();
    state = state.copyWith(inventory: updatedInventory);
  }

  void addToInventory(List<LabTest> selectedTests) {
    // Add only tests that are not already in inventory
    final currentIds = state.inventory.map((t) => t.id).toSet();
    final newTests = selectedTests
        .where((t) => !currentIds.contains(t.id))
        .toList();

    state = state.copyWith(inventory: [...state.inventory, ...newTests]);
  }

  List<LabTest> get filteredInventory {
    return state.inventory.where((test) {
      final matchesSearch =
          state.searchQuery == null ||
          test.name.toLowerCase().contains(state.searchQuery!.toLowerCase());
      final matchesCategory =
          state.categoryFilter == null ||
          state.categoryFilter == 'All' ||
          test.category == state.categoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<LabTest> get filteredAvailableTests {
    return state.availableTests.where((test) {
      final matchesSearch =
          state.searchQuery == null ||
          test.name.toLowerCase().contains(state.searchQuery!.toLowerCase());
      return matchesSearch;
    }).toList();
  }
}
