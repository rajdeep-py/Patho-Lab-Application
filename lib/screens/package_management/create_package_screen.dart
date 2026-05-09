import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/package.dart';
import '../../providers/package_provider.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class CreatePackageScreen extends ConsumerStatefulWidget {
  final LabPackage? package;

  const CreatePackageScreen({super.key, this.package});

  @override
  ConsumerState<CreatePackageScreen> createState() =>
      _CreatePackageScreenState();
}

class _CreatePackageScreenState extends ConsumerState<CreatePackageScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _photoUrlController;
  late TextEditingController _sampleTimeController;
  late TextEditingController _deliveryTimeController;

  List<String> _selectedTestIds = [];
  String? _selectedCategoryFilter;

  bool get isEdit => widget.package != null;

  @override
  void initState() {
    super.initState();
    final pkg = widget.package;
    _nameController = TextEditingController(text: pkg?.name ?? '');
    _priceController = TextEditingController(text: pkg?.price.toString() ?? '');
    _descriptionController = TextEditingController(
      text: pkg?.description ?? '',
    );
    _photoUrlController = TextEditingController(text: pkg?.photoUrl ?? '');
    _sampleTimeController = TextEditingController(
      text: pkg?.sampleCollectionTime ?? '',
    );
    _deliveryTimeController = TextEditingController(
      text: pkg?.reportDeliveryTime ?? '',
    );

    if (pkg != null) {
      _selectedTestIds = List.from(pkg.labTestIds);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _photoUrlController.dispose();
    _sampleTimeController.dispose();
    _deliveryTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null) {
      final file = result.files.single;
      if (kIsWeb) {
        if (file.bytes != null) {
          final base64Str = base64Encode(file.bytes!);
          setState(() {
            _photoUrlController.text = 'data:image/png;base64,$base64Str';
          });
        }
      } else {
        if (file.path != null) {
          setState(() {
            _photoUrlController.text = file.path!;
          });
        }
      }
    }
  }

  Widget _buildTestSelectionSection() {
    final allTests = ref.watch(testProvider);
    final categories = allTests.map((t) => t.category).toSet().toList();
    categories.sort();

    final availableTests = _selectedCategoryFilter == null
        ? allTests
        : allTests.where((t) => t.category == _selectedCategoryFilter).toList();

    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(IconsaxPlusLinear.document_filter, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Available Lab Tests',
                      style: AppTextStyles.header.copyWith(fontSize: 20),
                    ),
                  ],
                ),
                PopupMenuButton<String?>(
                  icon: const Icon(IconsaxPlusLinear.filter, color: AppColors.primary),
                  tooltip: 'Filter by Category',
                  onSelected: (String? category) {
                    setState(() {
                      _selectedCategoryFilter = category;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String?>(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...categories.map((String category) {
                        return PopupMenuItem<String?>(
                          value: category,
                          child: Text(category),
                        );
                      }),
                    ];
                  },
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              itemCount: availableTests.length,
              itemBuilder: (context, index) {
                final test = availableTests[index];
                final isSelected = _selectedTestIds.contains(test.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withAlpha(15)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary.withAlpha(50)
                          : AppColors.divider,
                      width: 1.5,
                    ),
                  ),
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            test.name,
                            style: AppTextStyles.subHeader.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          '₹${test.price.toStringAsFixed(0)}',
                          style: AppTextStyles.subHeader.copyWith(
                            color: AppColors.secondaryCyan,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        test.category,
                        style: AppTextStyles.caption,
                      ),
                    ),
                    value: isSelected,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedTestIds.add(test.id);
                        } else {
                          _selectedTestIds.remove(test.id);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Selected', style: AppTextStyles.description),
                Text(
                  '${_selectedTestIds.length} Tests',
                  style: AppTextStyles.header.copyWith(
                    color: AppColors.primary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalValue() {
    double total = 0;
    final tests = ref.read(testProvider);
    for (final id in _selectedTestIds) {
      try {
        final test = tests.firstWhere((t) => t.id == id);
        total += test.price;
      } catch (_) {}
    }
    return total;
  }

  Widget _buildSelectedTestsSection() {
    final tests = ref.watch(testProvider);
    final selectedTests = tests.where((t) => _selectedTestIds.contains(t.id)).toList();
    
    // Group by category
    final Map<String, List<dynamic>> groupedSelectedTests = {};
    for (final test in selectedTests) {
      if (!groupedSelectedTests.containsKey(test.category)) {
        groupedSelectedTests[test.category] = [];
      }
      groupedSelectedTests[test.category]!.add(test);
    }
    
    final sortedCategories = groupedSelectedTests.keys.toList()..sort();

    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Icon(IconsaxPlusLinear.tick_square, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Selected Tests',
                  style: AppTextStyles.header.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          Expanded(
            child: _selectedTestIds.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(IconsaxPlusLinear.document_favorite, color: AppColors.textTertiary, size: 48),
                        const SizedBox(height: 16),
                        const Text(
                          'No tests selected',
                          style: AppTextStyles.description,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedCategories.length,
                    itemBuilder: (context, catIndex) {
                      final category = sortedCategories[catIndex];
                      final catTests = groupedSelectedTests[category]!;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 12, top: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  category,
                                  style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          ...catTests.map((test) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primary.withAlpha(50)),
                              ),
                              child: ListTile(
                                title: Text(test.name, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                subtitle: Text('₹${test.price.toStringAsFixed(0)}', style: TextStyle(color: AppColors.primary.withAlpha(200))),
                                trailing: IconButton(
                                  icon: const Icon(IconsaxPlusLinear.close_circle, color: AppColors.primary),
                                  onPressed: () {
                                    setState(() {
                                      _selectedTestIds.remove(test.id);
                                    });
                                  },
                                ),
                              ),
                            ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1);
                          }),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Value', style: AppTextStyles.description),
                Text(
                  '₹${_calculateTotalValue().toStringAsFixed(0)}',
                  style: AppTextStyles.header.copyWith(color: AppColors.primary, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _savePackage() {
    if (_formKey.currentState!.validate()) {
      final newPackage = LabPackage(
        id: isEdit
            ? widget.package!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        labTestIds: _selectedTestIds,
        sampleCollectionTime: _sampleTimeController.text,
        reportDeliveryTime: _deliveryTimeController.text,
        photoUrl: _photoUrlController.text.isEmpty
            ? 'https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=2070&auto=format&fit=crop'
            : _photoUrlController.text,
      );

      if (isEdit) {
        ref.read(packageProvider.notifier).updatePackage(newPackage);
      } else {
        ref.read(packageProvider.notifier).addPackage(newPackage);
      }

      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Package updated successfully'
                : 'Package created successfully',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: isEdit ? 'Edit Package' : 'Create Package',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(
              IconsaxPlusLinear.tick_circle,
              color: AppColors.primary,
            ),
            onPressed: _savePackage,
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Available Tests
          Expanded(
            flex: 2,
            child: _buildTestSelectionSection(),
          ),
          Container(width: 1, color: AppColors.divider),
          
          // Middle: Selected Tests
          Expanded(
            flex: 2,
            child: _buildSelectedTestsSection(),
          ),
          Container(width: 1, color: AppColors.divider),
          
          // Right: Form
          Expanded(
            flex: 3,
            child: Container(
              color: AppColors.surface,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  children: [
                    // Basic Information Card
                    Container(
                      decoration: AppCardStyles.sleekCard,
                      padding: const EdgeInsets.all(AppSpacing.cardPadding),
                      margin: const EdgeInsets.only(bottom: AppSpacing.elementGap),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Basic Information',
                            style: AppTextStyles.cardTitle,
                          ),
                          const SizedBox(height: AppSpacing.elementGap),
                          _buildTextField(
                            _nameController,
                            'Package Name',
                            IconsaxPlusLinear.box,
                          ),
                          const SizedBox(height: AppSpacing.elementGap),
                          _buildTextField(
                            _priceController,
                            'Price',
                            IconsaxPlusLinear.wallet_2,
                            isNumeric: true,
                          ),
                          const SizedBox(height: AppSpacing.elementGap),
                          _buildTextField(
                            _descriptionController,
                            'Description',
                            IconsaxPlusLinear.document_text,
                            maxLines: 3,
                          ),
                          const SizedBox(height: AppSpacing.elementGap),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  _photoUrlController,
                                  'Photo Path (or pick an image)',
                                  IconsaxPlusLinear.gallery,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  IconsaxPlusLinear.document_upload,
                                  color: AppColors.primary,
                                ),
                                onPressed: _pickImage,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

                    // Collection & Delivery Card
                    Container(
                      decoration: AppCardStyles.sleekCard,
                      padding: const EdgeInsets.all(AppSpacing.cardPadding),
                      margin: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Collection & Delivery',
                            style: AppTextStyles.cardTitle,
                          ),
                          const SizedBox(height: AppSpacing.elementGap),
                          _buildTextField(
                            _sampleTimeController,
                            'Sample Collection Time',
                            IconsaxPlusLinear.timer,
                          ),
                          const SizedBox(height: AppSpacing.elementGap),
                          _buildTextField(
                            _deliveryTimeController,
                            'Report Delivery Time',
                            IconsaxPlusLinear.truck_fast,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _savePackage,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isEdit ? 'Update Package' : 'Create Package',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: AppSpacing.sectionGap),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumeric = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: AppTextStyles.description,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textTertiary),
        prefixIcon: Icon(icon, color: AppColors.primaryAccent, size: 20),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (label != 'Photo Path (or pick an image)') {
            return 'Please enter $label';
          }
        }
        if (isNumeric && double.tryParse(value!) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
