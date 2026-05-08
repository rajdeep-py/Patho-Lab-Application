import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/test_provider.dart';

class TestDetailsScreen extends ConsumerStatefulWidget {
  final LabTest test;

  const TestDetailsScreen({super.key, required this.test});

  @override
  ConsumerState<TestDetailsScreen> createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends ConsumerState<TestDetailsScreen> {
  bool _isEditing = false;
  late TextEditingController _priceController;
  late TextEditingController _collectionController;
  late TextEditingController _deliveryController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.test.price.toStringAsFixed(0));
    _collectionController = TextEditingController(text: widget.test.sampleCollectionFlow);
    _deliveryController = TextEditingController(text: widget.test.deliveryReportFlow);
  }

  @override
  void dispose() {
    _priceController.dispose();
    _collectionController.dispose();
    _deliveryController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    ref.read(testProvider.notifier).updateTestDetails(
      widget.test.id,
      price: double.tryParse(_priceController.text),
      collectionFlow: _collectionController.text,
      deliveryFlow: _deliveryController.text,
    );
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test profile updated successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Test Profile',
        subtitle: widget.test.name,
        showBackButton: true,
        actions: [
          _buildEditActionButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroHeader(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceSection(),
                  const SizedBox(height: 32),
                  _buildInfoSection('Description', widget.test.description, IconsaxPlusLinear.document_text_1),
                  const SizedBox(height: 32),
                  _buildParametersSection(),
                  const SizedBox(height: 32),
                  _buildInfoSection('Precautions', widget.test.precautions, IconsaxPlusLinear.info_circle, color: AppColors.warning),
                  const SizedBox(height: 40),
                  const Divider(height: 1),
                  const SizedBox(height: 40),
                  _buildWorkflowSection(
                    'Sample Collection',
                    _collectionController,
                    IconsaxPlusLinear.glass_1,
                  ),
                  const SizedBox(height: 32),
                  _buildWorkflowSection(
                    'Report Delivery Flow',
                    _deliveryController,
                    IconsaxPlusLinear.routing,
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isEditing ? _buildSaveButton() : null,
    );
  }

  Widget _buildEditActionButton() {
    return IconButton(
      onPressed: () {
        if (_isEditing) {
          _saveChanges();
        } else {
          setState(() => _isEditing = true);
        }
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isEditing ? AppColors.success : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (_isEditing ? AppColors.success : AppColors.primary).withAlpha(40),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(
          _isEditing ? IconsaxPlusLinear.tick_circle : IconsaxPlusLinear.edit_2,
          size: 20,
          color: _isEditing ? Colors.white : AppColors.primaryAccent,
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Stack(
      children: [
        Hero(
          tag: 'test_image_${widget.test.id}',
          child: Container(
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.test.photoUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(180),
                    Colors.transparent,
                    AppColors.background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  widget.test.category.toUpperCase(),
                  style: AppTextStyles.tagline.copyWith(color: Colors.white, fontSize: 10),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.test.name,
                style: AppTextStyles.header.copyWith(color: AppColors.textPrimary, fontSize: 28),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.primaryGradientCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TEST PRICE', style: AppTextStyles.tagline.copyWith(color: Colors.white.withAlpha(180), fontSize: 10)),
              const SizedBox(height: 4),
              if (_isEditing)
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.header.copyWith(color: Colors.white, fontSize: 24),
                    decoration: const InputDecoration(
                      prefixText: '₹',
                      prefixStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                    ),
                  ),
                )
              else
                Text('₹${widget.test.price.toStringAsFixed(0)}', style: AppTextStyles.header.copyWith(color: Colors.white, fontSize: 32)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(IconsaxPlusLinear.wallet_1, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 22, color: color ?? AppColors.primaryAccent),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.subHeader.copyWith(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider.withAlpha(100)),
          ),
          child: Text(content, style: AppTextStyles.description.copyWith(fontSize: 15)),
        ),
      ],
    );
  }

  Widget _buildParametersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(IconsaxPlusLinear.category_2, size: 22, color: AppColors.primaryAccent),
            const SizedBox(width: 12),
            Text('Parameters Covered', style: AppTextStyles.subHeader.copyWith(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.test.parameters.map((p) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withAlpha(30)),
            ),
            child: Text(
              p,
              style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildWorkflowSection(String title, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 22, color: AppColors.primaryAccent),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.subHeader.copyWith(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        if (_isEditing)
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter process details...',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider.withAlpha(100)),
            ),
            child: Text(controller.text, style: AppTextStyles.description.copyWith(height: 1.6)),
          ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('Save Changes'),
        ),
      ),
    );
  }
}
