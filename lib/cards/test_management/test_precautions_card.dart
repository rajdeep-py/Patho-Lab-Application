import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/test.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';

class TestPrecautionsCard extends ConsumerStatefulWidget {
  final LabTest test;

  const TestPrecautionsCard({super.key, required this.test});

  @override
  ConsumerState<TestPrecautionsCard> createState() =>
      _TestPrecautionsCardState();
}

class _TestPrecautionsCardState extends ConsumerState<TestPrecautionsCard> {
  void _editPrecautions() {
    showDialog(
      context: context,
      builder: (context) => _EditPrecautionsDialog(test: widget.test),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.elementGap,
      ),
      decoration: AppCardStyles.sleekCard.copyWith(
        border: Border.all(color: AppColors.warning.withAlpha(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      IconsaxPlusLinear.warning_2,
                      color: AppColors.primaryAccent,
                    ),
                    const SizedBox(width: AppSpacing.elementGap),
                    Text(
                      'Test Precautions',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    IconsaxPlusLinear.edit_2,
                    color: AppColors.primary,
                  ),
                  onPressed: _editPrecautions,
                ),
              ],
            ),
            if (widget.test.precautions.isNotEmpty)
              const SizedBox(height: AppSpacing.elementGap),
            ...widget.test.precautions.map(
              (precaution) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: AppTextStyles.description.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                    Expanded(
                      child: Text(precaution, style: AppTextStyles.description),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditPrecautionsDialog extends ConsumerStatefulWidget {
  final LabTest test;
  const _EditPrecautionsDialog({required this.test});

  @override
  ConsumerState<_EditPrecautionsDialog> createState() =>
      _EditPrecautionsDialogState();
}

class _EditPrecautionsDialogState
    extends ConsumerState<_EditPrecautionsDialog> {
  late List<String> _precautions;
  final _precautionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _precautions = List.from(widget.test.precautions);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Precautions', style: AppTextStyles.cardTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _precautionController,
                    decoration: const InputDecoration(
                      hintText: 'Add precaution',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(IconsaxPlusLinear.add_circle, color: AppColors.primary),
                  onPressed: () {
                    if (_precautionController.text.isNotEmpty) {
                      setState(() {
                        _precautions.add(_precautionController.text);
                        _precautionController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._precautions.asMap().entries.map(
              (e) => ListTile(
                title: Text(e.value, style: AppTextStyles.description),
                trailing: IconButton(
                  icon: const Icon(IconsaxPlusLinear.trash, color: AppColors.error),
                  onPressed: () {
                    setState(() {
                      _precautions.removeAt(e.key);
                    });
                  },
                ),
              ),
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
            final updated = widget.test.copyWith(precautions: _precautions);
            ref.read(testProvider.notifier).updateTest(updated);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
