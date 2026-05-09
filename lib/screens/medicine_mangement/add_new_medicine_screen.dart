import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'dart:math';
import '../../models/medicine.dart';
import '../../theme/app_theme.dart';
import '../../providers/medicine_provider.dart';
import '../../widgets/app_bar.dart';

class AddNewMedicineScreen extends ConsumerStatefulWidget {
  const AddNewMedicineScreen({super.key});

  @override
  ConsumerState<AddNewMedicineScreen> createState() =>
      _AddNewMedicineScreenState();
}

class _AddNewMedicineScreenState extends ConsumerState<AddNewMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _compositionController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _photoUrlController = TextEditingController(
    text:
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop&q=60',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _compositionController.dispose();
    _manufacturerController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Register New Medicine',
        subtitle: 'Add a new product to the global clinical catalog',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: AppCardStyles.sleekCard,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Medicine Name',
                      hint: 'e.g. Paracetamol 500mg',
                      icon: IconsaxPlusLinear.health,
                      validator: (v) => v!.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _manufacturerController,
                      label: 'Manufacturer',
                      hint: 'e.g. GSK Pharmaceuticals',
                      icon: IconsaxPlusLinear.building,
                      validator: (v) =>
                          v!.isEmpty ? 'Manufacturer is required' : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _priceController,
                            label: 'Standard Price (MRP)',
                            hint: '0.00',
                            prefix: '₹ ',
                            keyboardType: TextInputType.number,
                            icon: IconsaxPlusLinear.wallet,
                            validator: (v) =>
                                v!.isEmpty ? 'Price is required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _quantityController,
                            label: 'Quantity in Pack',
                            hint: 'e.g. 10',
                            keyboardType: TextInputType.number,
                            icon: IconsaxPlusLinear.box,
                            validator: (v) =>
                                v!.isEmpty ? 'Quantity is required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _compositionController,
                      label: 'Clinical Composition',
                      hint: 'e.g. Paracetamol, Caffeine',
                      icon: IconsaxPlusLinear.document_text,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _photoUrlController,
                      label: 'Medicine Photo URL',
                      hint: 'https://...',
                      icon: IconsaxPlusLinear.image,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Clinical Description',
                      hint: 'Describe the medicine usage and side effects...',
                      icon: IconsaxPlusLinear.info_circle,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: const Text('REGISTER TO CATALOG'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? prefix,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            prefixIcon: Icon(icon, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newMedicine = Medicine(
        id: Random().nextInt(10000).toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        photoUrl: _photoUrlController.text,
        composition: _compositionController.text,
        manufacturer: _manufacturerController.text,
      );

      ref.read(medicineProvider.notifier).addToCatalog(newMedicine);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicine registered to global catalog successfully!'),
        ),
      );
      context.pop();
    }
  }
}
