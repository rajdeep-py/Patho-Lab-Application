import 'package:flutter/material.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';

class TestCollectionDeliveryCard extends StatelessWidget {
  final LabTest test;

  const TestCollectionDeliveryCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.elementGap),
      decoration: AppCardStyles.primaryGradientCard,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          children: [
            _buildRow(Icons.bloodtype_outlined, 'Sample Type', test.sampleCollectionType),
            const Divider(height: AppSpacing.sectionGap, color: Colors.white24),
            _buildRow(Icons.timer_outlined, 'Collection Time', test.sampleCollectionTime),
            const Divider(height: AppSpacing.sectionGap, color: Colors.white24),
            _buildRow(Icons.local_shipping_outlined, 'Report Delivery', test.reportDeliveryTime),
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
              Text(
                title,
                style: AppTextStyles.caption.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.description.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
