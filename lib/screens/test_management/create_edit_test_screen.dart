import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/test.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';

class CreateEditTestScreen extends ConsumerStatefulWidget {
  final LabTest? test;

  const CreateEditTestScreen({super.key, this.test});

  @override
  ConsumerState<CreateEditTestScreen> createState() => _CreateEditTestScreenState();
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
    _priceController = TextEditingController(text: test?.price.toString() ?? '');
    _photoUrlController = TextEditingController(text: test?.photoUrl ?? '');
    _descriptionController = TextEditingController(text: test?.detailedDescription ?? '');
    _sampleTypeController = TextEditingController(text: test?.sampleCollectionType ?? '');
    _sampleTimeController = TextEditingController(text: test?.sampleCollectionTime ?? '');
    _deliveryTimeController = TextEditingController(text: test?.reportDeliveryTime ?? '');
    
    if (test != null) {
      _parameters = List.from(test.parameters);
      _precautions = List.from(test.precautions);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _photoUrlController.dispose();
    _descriptionController.dispose();
    _sampleTypeController.dispose();
    _sampleTimeController.dispose();
    _deliveryTimeController.dispose();
    _paramController.dispose();
    _precautionController.dispose();
    super.dispose();
  }

  void _saveTest() {
    if (_formKey.currentState!.validate()) {
      final newTest = LabTest(
        id: isEdit ? widget.test!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        category: _categoryController.text,
        price: double.parse(_priceController.text),
        photoUrl: _photoUrlController.text.isEmpty ? 'https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=2070&auto=format&fit=crop' : _photoUrlController.text,
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
        SnackBar(content: Text(isEdit ? 'Test updated successfully' : 'Test created successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(isEdit ? 'Edit Lab Test' : 'Create New Lab Test', style: AppTextStyles.subHeader),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline, color: AppColors.primary),
            onPressed: _saveTest,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            _buildSectionTitle('Basic Information'),
            _buildTextField(_nameController, 'Test Name', Icons.science_outlined),
            const SizedBox(height: AppSpacing.elementGap),
            _buildTextField(_categoryController, 'Category (e.g. Blood Test)', Icons.category_outlined),
            const SizedBox(height: AppSpacing.elementGap),
            _buildTextField(_priceController, 'Price', Icons.currency_rupee_outlined, isNumeric: true),
            const SizedBox(height: AppSpacing.elementGap),
            _buildTextField(_photoUrlController, 'Photo URL', Icons.image_outlined),
            
            const SizedBox(height: AppSpacing.sectionGap),
            _buildSectionTitle('Detailed Description'),
            _buildTextField(_descriptionController, 'Description', Icons.description_outlined, maxLines: 3),
            
            const SizedBox(height: AppSpacing.sectionGap),
            _buildSectionTitle('Parameters Included'),
            _buildListEditor('Parameter', _parameters, _paramController),
            
            const SizedBox(height: AppSpacing.sectionGap),
            _buildSectionTitle('Precautions'),
            _buildListEditor('Precaution', _precautions, _precautionController),
            
            const SizedBox(height: AppSpacing.sectionGap),
            _buildSectionTitle('Collection & Delivery'),
            _buildTextField(_sampleTypeController, 'Sample Type', Icons.bloodtype_outlined),
            const SizedBox(height: AppSpacing.elementGap),
            _buildTextField(_sampleTimeController, 'Sample Collection Time', Icons.timer_outlined),
            const SizedBox(height: AppSpacing.elementGap),
            _buildTextField(_deliveryTimeController, 'Report Delivery Time', Icons.local_shipping_outlined),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveTest,
              child: Text(isEdit ? 'Update Lab Test' : 'Create Lab Test'),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.elementGap),
      child: Text(
        title,
        style: AppTextStyles.cardTitle,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumeric = false, int maxLines = 1}) {
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

  Widget _buildListEditor(String label, List<String> list, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                style: AppTextStyles.description,
                decoration: InputDecoration(
                  labelText: 'Add $label',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.elementGap),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
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
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () {
                  setState(() {
                    list.removeAt(index);
                  });
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
