import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/test.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class CreateEditTestScreen extends ConsumerStatefulWidget {
  final LabTest? test;

  const CreateEditTestScreen({super.key, this.test});

  @override
  ConsumerState<CreateEditTestScreen> createState() =>
      _CreateEditTestScreenState();
}

class _CreateEditTestScreenState extends ConsumerState<CreateEditTestScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _photoUrlController;
  late TextEditingController _descriptionController;
  late TextEditingController _sampleTypeController;
  late TextEditingController _sampleTimeController;
  late TextEditingController _deliveryTimeController;

  List<String> _parameters = [];
  List<String> _precautions = [];

  final _paramController = TextEditingController();
  final _precautionController = TextEditingController();

  bool get isEdit => widget.test != null;

  @override
  void initState() {
    super.initState();
    final test = widget.test;
    _nameController = TextEditingController(text: test?.name ?? '');
    _categoryController = TextEditingController(text: test?.category ?? '');
    _priceController = TextEditingController(
      text: test?.price.toString() ?? '',
    );
    _photoUrlController = TextEditingController(text: test?.photoUrl ?? '');
    _descriptionController = TextEditingController(
      text: test?.detailedDescription ?? '',
    );
    _sampleTypeController = TextEditingController(
      text: test?.sampleCollectionType ?? '',
    );
    _sampleTimeController = TextEditingController(
      text: test?.sampleCollectionTime ?? '',
    );
    _deliveryTimeController = TextEditingController(
      text: test?.reportDeliveryTime ?? '',
    );

    if (test != null) {
      _parameters = List.from(test.parameters);
      _precautions = List.from(test.precautions);
    }
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

  void _saveTest() {
    if (_formKey.currentState!.validate()) {
      final newTest = LabTest(
        id: isEdit
            ? widget.test!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        category: _categoryController.text,
        price: double.parse(_priceController.text),
        photoUrl: _photoUrlController.text.isEmpty
            ? 'https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=2070&auto=format&fit=crop'
            : _photoUrlController.text,
        detailedDescription: _descriptionController.text,
        parameters: _parameters,
        precautions: _precautions,
        sampleCollectionType: _sampleTypeController.text,
        sampleCollectionTime: _sampleTimeController.text,
        reportDeliveryTime: _deliveryTimeController.text,
      );

      if (isEdit) {
        ref.read(testProvider.notifier).updateTest(newTest);
      } else {
        ref.read(testProvider.notifier).addTest(newTest);
      }

      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit ? 'Test updated successfully' : 'Test created successfully',
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
        title: isEdit ? 'Edit Lab Test' : 'Create New Lab Test',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(
              IconsaxPlusLinear.tick_circle,
              color: AppColors.primary,
            ),
            onPressed: _saveTest,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Container(
              decoration: AppCardStyles.sleekCard,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              margin: const EdgeInsets.only(bottom: AppSpacing.elementGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Basic Information'),
                  _buildTextField(
                    _nameController,
                    'Test Name',
                    IconsaxPlusLinear.activity,
                  ),
                  const SizedBox(height: AppSpacing.elementGap),
                  _buildTextField(
                    _categoryController,
                    'Category (e.g. Blood Test)',
                    IconsaxPlusLinear.category,
                  ),
                  const SizedBox(height: AppSpacing.elementGap),
                  _buildTextField(
                    _priceController,
                    'Price',
                    IconsaxPlusLinear.wallet_2,
                    isNumeric: true,
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

            Container(
              decoration: AppCardStyles.sleekCard,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              margin: const EdgeInsets.only(bottom: AppSpacing.elementGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Detailed Description'),
                  _buildTextField(
                    _descriptionController,
                    'Description',
                    IconsaxPlusLinear.document_text,
                    maxLines: 3,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),

            Container(
              decoration: AppCardStyles.sleekCard,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              margin: const EdgeInsets.only(bottom: AppSpacing.elementGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Parameters Included'),
                  _buildListEditor('Parameter', _parameters, _paramController),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1),

            Container(
              decoration: AppCardStyles.sleekCard,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              margin: const EdgeInsets.only(bottom: AppSpacing.elementGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Precautions'),
                  _buildListEditor('Precaution', _precautions, _precautionController),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1),

            Container(
              decoration: AppCardStyles.sleekCard,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              margin: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Collection & Delivery'),
                  _buildTextField(
                    _sampleTypeController,
                    'Sample Type',
                    IconsaxPlusLinear.drop,
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
            ).animate().fadeIn(duration: 400.ms, delay: 250.ms).slideY(begin: 0.1),

            ElevatedButton(
              onPressed: _saveTest,
              child: Text(isEdit ? 'Update Lab Test' : 'Create Lab Test'),
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.elementGap),
      child: Text(title, style: AppTextStyles.cardTitle),
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
          if (label != 'Photo URL') {
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

  Widget _buildListEditor(
    String label,
    List<String> list,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                style: AppTextStyles.description,
                decoration: InputDecoration(labelText: 'Add $label'),
              ),
            ),
            const SizedBox(width: AppSpacing.elementGap),
            IconButton(
              icon: const Icon(
                IconsaxPlusLinear.add_circle,
                color: AppColors.primary,
                size: 32,
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    list.add(controller.text);
                    controller.clear();
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.elementGap),
        ...list.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: AppCardStyles.sleekCard,
            child: ListTile(
              title: Text(item, style: AppTextStyles.description),
              trailing: IconButton(
                icon: const Icon(
                  IconsaxPlusLinear.trash,
                  color: AppColors.error,
                ),
                onPressed: () {
                  setState(() {
                    list.removeAt(index);
                  });
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
