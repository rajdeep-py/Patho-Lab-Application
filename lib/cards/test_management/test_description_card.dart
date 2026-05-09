import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/test.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';

class TestDescriptionCard extends ConsumerStatefulWidget {
  final LabTest test;

  const TestDescriptionCard({super.key, required this.test});

  @override
  ConsumerState<TestDescriptionCard> createState() =>
      _TestDescriptionCardState();
}

class _TestDescriptionCardState extends ConsumerState<TestDescriptionCard> {
  void _editDescription() {
    showDialog(
      context: context,
      builder: (context) => _EditDescriptionDialog(test: widget.test),
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
                const Text(
                  'Detailed Description',
                  style: AppTextStyles.cardTitle,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: _editDescription,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.elementGap),
            Text(
              widget.test.detailedDescription,
              style: AppTextStyles.description,
            ),
            if (widget.test.parameters.isNotEmpty) ...[
              const Divider(
                height: AppSpacing.sectionGap,
                color: AppColors.divider,
              ),
              const Text('Parameters Included', style: AppTextStyles.cardTitle),
              const SizedBox(height: AppSpacing.elementGap),
              ...widget.test.parameters.map(
                (param) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.elementGap),
                      Expanded(
                        child: Text(param, style: AppTextStyles.description),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EditDescriptionDialog extends ConsumerStatefulWidget {
  final LabTest test;
  const _EditDescriptionDialog({required this.test});

  @override
  ConsumerState<_EditDescriptionDialog> createState() =>
      _EditDescriptionDialogState();
}

class _EditDescriptionDialogState
    extends ConsumerState<_EditDescriptionDialog> {
  late TextEditingController _descController;
  late List<String> _parameters;
  final _paramController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(
      text: widget.test.detailedDescription,
    );
    _parameters = List.from(widget.test.parameters);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Description', style: AppTextStyles.cardTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Detailed Description',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Parameters', style: AppTextStyles.cardTitle),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _paramController,
                    decoration: const InputDecoration(
                      hintText: 'Add parameter',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                  onPressed: () {
                    if (_paramController.text.isNotEmpty) {
                      setState(() {
                        _parameters.add(_paramController.text);
                        _paramController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._parameters.asMap().entries.map(
              (e) => ListTile(
                title: Text(e.value),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.error),
                  onPressed: () {
                    setState(() {
                      _parameters.removeAt(e.key);
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
            final updated = widget.test.copyWith(
              detailedDescription: _descController.text,
              parameters: _parameters,
            );
            ref.read(testProvider.notifier).updateTest(updated);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
