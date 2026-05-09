import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'test_image_${widget.test.id}',
              child: _buildTestImage(widget.test.photoUrl),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(0),
                    Colors.black.withAlpha(80),
                    Colors.black.withAlpha(200),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(80),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withAlpha(100),
                                ),
                              ),
                              child: Text(
                                widget.test.category.toUpperCase(),
                                style: AppTextStyles.tagline.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.test.name,
                              style: AppTextStyles.header.copyWith(
                                fontSize: 28,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${widget.test.price.toStringAsFixed(2)}',
                              style: AppTextStyles.subHeader.copyWith(
                                color: AppColors.primary,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          IconsaxPlusLinear.edit_2,
                          color: Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withAlpha(40),
                        ),
                        onPressed: _editHeader,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildErrorImage() {
    return Container(
      width: double.infinity,
      height: 200,
      color: AppColors.darkCyan,
      child: const Icon(
        IconsaxPlusLinear.activity,
        color: Colors.white54,
        size: 50,
      ),
    );
  }

  Widget _buildTestImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover, errorBuilder: _errorBuilder);
    } else if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        return Image.memory(
          base64Decode(base64Str),
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
