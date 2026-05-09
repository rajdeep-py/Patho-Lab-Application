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

  void _showTestSelectionDialog() {
    final availableTests = ref.read(testProvider);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Select Lab Tests',
                style: AppTextStyles.cardTitle,
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableTests.length,
                  itemBuilder: (context, index) {
                    final test = availableTests[index];
                    final isSelected = _selectedTestIds.contains(test.id);

                    return CheckboxListTile(
                      title: Text(test.name, style: AppTextStyles.description),
                      subtitle: Text(
                        test.category,
                        style: AppTextStyles.caption,
                      ),
                      value: isSelected,
                      activeColor: AppColors.primary,
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            _selectedTestIds.add(test.id);
                          } else {
                            _selectedTestIds.remove(test.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
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
      body: Form(
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
                  const Text('Basic Information', style: AppTextStyles.cardTitle),
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

            // Lab Tests Included Card
            Container(
              decoration: AppCardStyles.sleekCard,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              margin: const EdgeInsets.only(bottom: AppSpacing.elementGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Lab Tests Included',
                        style: AppTextStyles.cardTitle,
                      ),
                      TextButton.icon(
                        onPressed: _showTestSelectionDialog,
                        icon: const Icon(IconsaxPlusLinear.add),
                        label: const Text('Add Tests'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.elementGap),
                  if (_selectedTestIds.isEmpty)
                    const Text(
                      'No tests selected yet.',
                      style: AppTextStyles.description,
                    )
                  else
                    ..._selectedTestIds.map((id) {
                      final tests = ref.watch(testProvider);
                      try {
                        final test = tests.firstWhere((t) => t.id == id);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            IconsaxPlusBold.tick_circle,
                            color: AppColors.success,
                          ),
                          title: Text(test.name, style: AppTextStyles.description),
                          trailing: IconButton(
                            icon: const Icon(
                              IconsaxPlusLinear.minus_cirlce,
                              color: AppColors.error,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedTestIds.remove(id);
                              });
                            },
                          ),
                        );
                      } catch (_) {
                        return const SizedBox.shrink();
                      }
                    }),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),

            // Collection & Delivery Card
            Container(
              decoration: AppCardStyles.sleekCard,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              margin: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Collection & Delivery', style: AppTextStyles.cardTitle),
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
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1),

            ElevatedButton(
              onPressed: _savePackage,
              child: Text(isEdit ? 'Update Package' : 'Create Package'),
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
        ),
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
        prefixIcon: Icon(icon, color: AppColors.primary),
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
