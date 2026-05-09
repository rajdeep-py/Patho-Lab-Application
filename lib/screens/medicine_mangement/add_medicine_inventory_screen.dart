import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';
import '../../providers/medicine_provider.dart';
import '../../models/medicine.dart';
import '../../widgets/app_bar.dart';

class AddMedicineInventoryScreen extends ConsumerStatefulWidget {
  const AddMedicineInventoryScreen({super.key});

  @override
  ConsumerState<AddMedicineInventoryScreen> createState() =>
      _AddMedicineInventoryScreenState();
}

class _AddMedicineInventoryScreenState
    extends ConsumerState<AddMedicineInventoryScreen> {
  final List<Medicine> _selectedMedicines = [];
  final Map<String, TextEditingController> _priceControllers = {};
  String _catalogSearchQuery = '';

  @override
  void dispose() {
    for (var controller in _priceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicineState = ref.watch(medicineProvider);
    final catalogResults = medicineState.catalog
        .where(
          (m) =>
              m.name.toLowerCase().contains(
                _catalogSearchQuery.toLowerCase(),
              ) &&
              !medicineState.inventory.any((inv) => inv.id == m.id),
        )
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Add to Inventory',
        subtitle: 'Select medicines and set clinical prices',
        showBackButton: true,
        actions: [
          if (_selectedMedicines.isNotEmpty)
            IconButton(
              onPressed: _addSelectedToInventory,
              icon: const Icon(
                IconsaxPlusLinear.add_circle,
                color: AppColors.primaryAccent,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SECTION: Search and Select
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildSectionHeader(
                          '1. Search Medicines',
                          'Find items to add to your clinical stock',
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => context.push('/add-new-medicine'),
                        icon: const Icon(
                          IconsaxPlusLinear.add_circle,
                          size: 16,
                        ),
                        label: const Text(
                          'NOT FOUND? ADD NEW',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) =>
                        setState(() => _catalogSearchQuery = value),
                    decoration: const InputDecoration(
                      hintText: 'Search catalog...',
                      prefixIcon: Icon(
                        IconsaxPlusLinear.search_status,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: catalogResults.isEmpty
                        ? _buildEmptySearch()
                        : ListView.builder(
                            itemCount: catalogResults.length,
                            itemBuilder: (context, index) {
                              final medicine = catalogResults[index];
                              final isAlreadySelected = _selectedMedicines.any(
                                (m) => m.id == medicine.id,
                              );

                              return _CatalogItemTile(
                                medicine: medicine,
                                isSelected: isAlreadySelected,
                                onSelect: () => _toggleSelection(medicine),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          const VerticalDivider(width: 1, color: AppColors.divider),

          // RIGHT SECTION: Selected Items and Price Setting
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    '2. Clinical Pricing',
                    'Set your selling price for selected items',
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _selectedMedicines.isEmpty
                        ? _buildEmptySelection()
                        : ListView.builder(
                            itemCount: _selectedMedicines.length,
                            itemBuilder: (context, index) {
                              final medicine = _selectedMedicines[index];
                              return _SelectedMedicineRow(
                                medicine: medicine,
                                controller: _priceControllers[medicine.id]!,
                                onRemove: () => _toggleSelection(medicine),
                              );
                            },
                          ),
                  ),
                  if (_selectedMedicines.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addSelectedToInventory,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: Text(
                            'ADD ${_selectedMedicines.length} ITEMS TO INVENTORY',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSelection(Medicine medicine) {
    setState(() {
      final index = _selectedMedicines.indexWhere((m) => m.id == medicine.id);
      if (index >= 0) {
        _selectedMedicines.removeAt(index);
        _priceControllers[medicine.id]?.dispose();
        _priceControllers.remove(medicine.id);
      } else {
        _selectedMedicines.add(medicine);
        _priceControllers[medicine.id] = TextEditingController(
          text: medicine.price.toStringAsFixed(2),
        );
      }
    });
  }

  void _addSelectedToInventory() {
    for (var medicine in _selectedMedicines) {
      final customPrice =
          double.tryParse(_priceControllers[medicine.id]!.text) ??
          medicine.price;
      ref
          .read(medicineProvider.notifier)
          .addToInventory(medicine.copyWith(price: customPrice));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${_selectedMedicines.length} medicines to inventory!',
        ),
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.subHeader.copyWith(fontSize: 20)),
        Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            IconsaxPlusLinear.box_1,
            color: AppColors.textTertiary,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'No matching medicines in catalog',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            IconsaxPlusLinear.add_circle,
            color: AppColors.textTertiary,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Select medicines from the left to set prices',
            style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CatalogItemTile extends StatelessWidget {
  final Medicine medicine;
  final bool isSelected;
  final VoidCallback onSelect;

  const _CatalogItemTile({
    required this.medicine,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppCardStyles.sleekCard,
      child: ListTile(
        onTap: () => _showMedicineDetails(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            medicine.photoUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          medicine.name,
          style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
        ),
        subtitle: Text(
          medicine.manufacturer,
          style: AppTextStyles.caption.copyWith(fontSize: 10),
        ),
        trailing: IconButton(
          onPressed: onSelect,
          icon: Icon(
            isSelected
                ? IconsaxPlusBold.minus_cirlce
                : IconsaxPlusBold.add_circle,
            color: isSelected ? AppColors.error : AppColors.primaryAccent,
          ),
        ),
      ),
    );
  }

  void _showMedicineDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  medicine.photoUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                medicine.name,
                style: AppTextStyles.header.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                medicine.manufacturer,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailItem('Description', medicine.description),
              _buildDetailItem('Composition', medicine.composition),
              _buildDetailItem(
                'Quantity in Pack',
                medicine.quantity.toString(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.tagline.copyWith(fontSize: 10)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.description.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}

class _SelectedMedicineRow extends StatelessWidget {
  final Medicine medicine;
  final TextEditingController controller;
  final VoidCallback onRemove;

  const _SelectedMedicineRow({
    required this.medicine,
    required this.controller,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
                ),
                Text(
                  'MRP: ₹${medicine.price.toStringAsFixed(2)}',
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
              style: AppTextStyles.cardTitle.copyWith(
                fontSize: 14,
                color: AppColors.primaryAccent,
              ),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(
              IconsaxPlusLinear.close_circle,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
