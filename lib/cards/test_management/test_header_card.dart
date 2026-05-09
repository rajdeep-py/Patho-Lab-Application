import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/test.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';

class TestHeaderCard extends ConsumerStatefulWidget {
  final LabTest test;

  const TestHeaderCard({super.key, required this.test});

  @override
  ConsumerState<TestHeaderCard> createState() => _TestHeaderCardState();
}

class _TestHeaderCardState extends ConsumerState<TestHeaderCard> {
  void _editHeader() {
    showDialog(
      context: context,
      builder: (context) => _EditHeaderDialog(test: widget.test),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.elementGap,
      ),
      decoration: AppCardStyles.sleekCard,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withAlpha(50)),
                  ),
                  child: Text(
                    widget.test.category.toUpperCase(),
                    style: AppTextStyles.tagline,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    IconsaxPlusLinear.edit_2,
                    color: AppColors.primary,
                  ),
                  onPressed: _editHeader,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.elementGap),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.elementGap),
              child: _buildTestImage(widget.test.photoUrl),
            ),
            const SizedBox(height: AppSpacing.elementGap),
            Text(
              widget.test.name,
              style: AppTextStyles.header.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${widget.test.price.toStringAsFixed(2)}',
              style: AppTextStyles.subHeader.copyWith(
                color: AppColors.primaryAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      width: double.infinity,
      height: 200,
      color: AppColors.blush,
      child: const Icon(IconsaxPlusLinear.activity, color: AppColors.textTertiary, size: 50),
    );
  }

  Widget _buildTestImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: _errorBuilder,
      );
    } else if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        return Image.memory(
          base64Decode(base64Str),
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: _errorBuilder,
        );
      } catch (e) {
        return _buildErrorImage();
      }
    } else {
      if (kIsWeb || url.isEmpty) {
        return _buildErrorImage();
      }
      return Image.file(
        File(url),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: _errorBuilder,
      );
    }
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return _buildErrorImage();
  }
}

class _EditHeaderDialog extends ConsumerStatefulWidget {
  final LabTest test;
  const _EditHeaderDialog({required this.test});

  @override
  ConsumerState<_EditHeaderDialog> createState() => _EditHeaderDialogState();
}

class _EditHeaderDialogState extends ConsumerState<_EditHeaderDialog> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.test.name);
    _categoryController = TextEditingController(text: widget.test.category);
    _priceController = TextEditingController(
      text: widget.test.price.toString(),
    );
    _photoUrl = widget.test.photoUrl;
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null) {
      final file = result.files.single;
      if (kIsWeb) {
        if (file.bytes != null) {
          final base64Str = base64Encode(file.bytes!);
          setState(() {
            _photoUrl = 'data:image/png;base64,$base64Str';
          });
        }
      } else {
        if (file.path != null) {
          setState(() {
            _photoUrl = file.path!;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Header', style: AppTextStyles.cardTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.blush,
                  borderRadius: BorderRadius.circular(12),
                  image: _photoUrl.isNotEmpty
                      ? _getDecorationImage(_photoUrl)
                      : null,
                ),
                child: _photoUrl.isEmpty
                    ? const Icon(
                        IconsaxPlusLinear.camera,
                        size: 40,
                        color: AppColors.textTertiary,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Test Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = widget.test.copyWith(
              name: _nameController.text,
              category: _categoryController.text,
              price:
                  double.tryParse(_priceController.text) ?? widget.test.price,
              photoUrl: _photoUrl,
            );
            ref.read(testProvider.notifier).updateTest(updated);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  DecorationImage? _getDecorationImage(String url) {
    if (url.isEmpty) return null;
    if (url.startsWith('http')) {
      return DecorationImage(image: NetworkImage(url), fit: BoxFit.cover);
    } else if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        return DecorationImage(
          image: MemoryImage(base64Decode(base64Str)),
          fit: BoxFit.cover,
        );
      } catch (e) {
        return null;
      }
    } else {
      if (kIsWeb) return null;
      return DecorationImage(image: FileImage(File(url)), fit: BoxFit.cover);
    }
  }
}
