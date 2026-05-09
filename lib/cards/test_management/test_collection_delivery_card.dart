import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/test.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';

class TestCollectionDeliveryCard extends ConsumerStatefulWidget {
  final LabTest test;

  const TestCollectionDeliveryCard({super.key, required this.test});

  @override
  ConsumerState<TestCollectionDeliveryCard> createState() => _TestCollectionDeliveryCardState();
}

class _TestCollectionDeliveryCardState extends ConsumerState<TestCollectionDeliveryCard> {
  void _editCollectionDetails() {
    showDialog(
      context: context,
      builder: (context) => _EditCollectionDialog(test: widget.test),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.elementGap),
      decoration: AppCardStyles.primaryGradientCard,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: _editCollectionDetails,
              ),
            ),
            _buildRow(Icons.bloodtype_outlined, 'Sample Type', widget.test.sampleCollectionType),
            const Divider(height: AppSpacing.sectionGap, color: Colors.white24),
            _buildRow(Icons.timer_outlined, 'Collection Time', widget.test.sampleCollectionTime),
            const Divider(height: AppSpacing.sectionGap, color: Colors.white24),
            _buildRow(Icons.local_shipping_outlined, 'Report Delivery', widget.test.reportDeliveryTime),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: AppSpacing.cardPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.description.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditCollectionDialog extends ConsumerStatefulWidget {
  final LabTest test;
  const _EditCollectionDialog({required this.test});

  @override
  ConsumerState<_EditCollectionDialog> createState() => _EditCollectionDialogState();
}

class _EditCollectionDialogState extends ConsumerState<_EditCollectionDialog> {
  late TextEditingController _sampleTypeController;
  late TextEditingController _sampleTimeController;
  late TextEditingController _deliveryTimeController;

  @override
  void initState() {
    super.initState();
    _sampleTypeController = TextEditingController(text: widget.test.sampleCollectionType);
    _sampleTimeController = TextEditingController(text: widget.test.sampleCollectionTime);
    _deliveryTimeController = TextEditingController(text: widget.test.reportDeliveryTime);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Collection Details', style: AppTextStyles.cardTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _sampleTypeController,
              decoration: const InputDecoration(labelText: 'Sample Type'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _sampleTimeController,
              decoration: const InputDecoration(labelText: 'Collection Time'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _deliveryTimeController,
              decoration: const InputDecoration(labelText: 'Report Delivery'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final updated = widget.test.copyWith(
              sampleCollectionType: _sampleTypeController.text,
              sampleCollectionTime: _sampleTimeController.text,
              reportDeliveryTime: _deliveryTimeController.text,
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
