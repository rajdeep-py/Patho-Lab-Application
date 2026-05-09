import 'package:flutter_riverpod/legacy.dart';
import '../models/medicine.dart';

class MedicineState {
  final List<Medicine> inventory;
  final List<Medicine> catalog; // All medicines available to add
  final bool isLoading;
  final String searchQuery;
  final double? maxPriceFilter;

  MedicineState({
    required this.inventory,
    required this.catalog,
    this.isLoading = false,
    this.searchQuery = '',
    this.maxPriceFilter,
  });

  MedicineState copyWith({
    List<Medicine>? inventory,
    List<Medicine>? catalog,
    bool? isLoading,
    String? searchQuery,
    double? maxPriceFilter,
  }) {
    return MedicineState(
      inventory: inventory ?? this.inventory,
      catalog: catalog ?? this.catalog,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      maxPriceFilter: maxPriceFilter ?? this.maxPriceFilter,
    );
  }

  List<Medicine> get filteredInventory {
    return inventory.where((m) {
      final matchesSearch = m.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesPrice = maxPriceFilter == null || m.price <= maxPriceFilter!;
      return matchesSearch && matchesPrice;
    }).toList();
  }
}

class MedicineNotifier extends StateNotifier<MedicineState> {
  MedicineNotifier() : super(MedicineState(inventory: [], catalog: [])) {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Dummy Inventory
    final initialInventory = [
      Medicine(
        id: '1',
        name: 'Paracetamol 500mg',
        description: 'Pain reliever and fever reducer.',
        price: 45.50,
        quantity: 120,
        photoUrl:
            'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop&q=60',
        composition: 'Paracetamol',
        manufacturer: 'GSK Pharmaceuticals',
      ),
      Medicine(
        id: '2',
        name: 'Amoxicillin 250mg',
        description: 'Antibiotic for bacterial infections.',
        price: 89.00,
        quantity: 45,
        photoUrl:
            'https://images.unsplash.com/photo-1550572017-ed2001594972?w=500&auto=format&fit=crop&q=60',
        composition: 'Amoxicillin Trihydrate',
        manufacturer: 'Abbott Laboratories',
      ),
    ];

    // Dummy Catalog for adding
    final catalog = [
      ...initialInventory,
      Medicine(
        id: '3',
        name: 'Ibuprofen 400mg',
        description: 'Nonsteroidal anti-inflammatory drug (NSAID).',
        price: 65.00,
        quantity: 200,
        photoUrl:
            'https://images.unsplash.com/photo-1587854692152-cbe660dbbb88?w=500&auto=format&fit=crop&q=60',
        composition: 'Ibuprofen',
        manufacturer: 'Pfizer',
      ),
      Medicine(
        id: '4',
        name: 'Cetirizine 10mg',
        description: 'Antihistamine for allergy symptoms.',
        price: 32.00,
        quantity: 150,
        photoUrl:
            'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=500&auto=format&fit=crop&q=60',
        composition: 'Cetirizine Hydrochloride',
        manufacturer: 'Sun Pharma',
      ),
    ];

    state = state.copyWith(inventory: initialInventory, catalog: catalog);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setPriceFilter(double? price) {
    state = state.copyWith(maxPriceFilter: price);
  }

  void updatePrice(String medicineId, double newPrice) {
    final newInventory = state.inventory.map((m) {
      if (m.id == medicineId) {
        return m.copyWith(price: newPrice);
      }
      return m;
    }).toList();
    state = state.copyWith(inventory: newInventory);
  }

  void removeFromInventory(String medicineId) {
    final newInventory = state.inventory
        .where((m) => m.id != medicineId)
        .toList();
    state = state.copyWith(inventory: newInventory);
  }

  void addToInventory(Medicine medicine) {
    if (!state.inventory.any((m) => m.id == medicine.id)) {
      state = state.copyWith(inventory: [...state.inventory, medicine]);
    }
  }
}
