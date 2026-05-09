import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/package.dart';
import '../../providers/package_provider.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';

class PackageDetailsScreen extends ConsumerWidget {
  final LabPackage package;

  const PackageDetailsScreen({super.key, required this.package});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatedPackage = ref
        .watch(packageProvider)
        .firstWhere((p) => p.id == package.id, orElse: () => package);
    final allTests = ref.watch(testProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Package Details',
          style: AppTextStyles.subHeader.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.edit_2, color: AppColors.primary),
            onPressed: () {
              context.push('/create-package', extra: updatedPackage);
            },
          ),
          IconButton(
            icon: const Icon(IconsaxPlusLinear.trash, color: AppColors.error),
            onPressed: () {
              _showDeleteConfirmation(context, ref, updatedPackage);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
        child: Column(
          children: [
            _buildHeaderCard(updatedPackage),
            _buildDescriptionCard(updatedPackage),
            _buildLabTestsIncluded(updatedPackage, allTests),
            _buildCollectionDeliveryCard(updatedPackage),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(LabPackage pkg) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.elementGap,
      ),
      decoration: AppCardStyles.sleekCard,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.elementGap),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: _getDecorationImage(pkg.photoUrl),
                color: AppColors.blush,
              ),
              child: _getDecorationImage(pkg.photoUrl) == null
                  ? const Icon(
                      IconsaxPlusLinear.box,
                      color: AppColors.textTertiary,
                      size: 50,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.elementGap),
          Text(pkg.name, style: AppTextStyles.header.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            '₹${pkg.price.toStringAsFixed(2)}',
            style: AppTextStyles.subHeader.copyWith(
              color: AppColors.primaryAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(LabPackage pkg) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.elementGap,
      ),
      decoration: AppCardStyles.sleekCard,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Package Description', style: AppTextStyles.cardTitle),
          const SizedBox(height: AppSpacing.elementGap),
          Text(pkg.description, style: AppTextStyles.description),
        ],
      ),
    );
  }

  Widget _buildLabTestsIncluded(LabPackage pkg, List<dynamic> allTests) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.elementGap,
      ),
      decoration: AppCardStyles.sleekCard,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lab Tests Included', style: AppTextStyles.cardTitle),
          const SizedBox(height: AppSpacing.elementGap),
          if (pkg.labTestIds.isEmpty)
            const Text(
              'No tests included in this package.',
              style: AppTextStyles.description,
            )
          else
            ...pkg.labTestIds.map((id) {
              try {
                final test = allTests.firstWhere((t) => t.id == id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            IconsaxPlusLinear.activity,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              test.name,
                              style: AppTextStyles.subHeader.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (test.detailedDescription.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 28, top: 4),
                          child: Text(
                            test.detailedDescription,
                            style: AppTextStyles.description,
                          ),
                        ),
                      if (test.parameters.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 28, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: test.parameters.map<Widget>((param) {
                              return Row(
                                children: [
                                  const Icon(
                                    IconsaxPlusLinear.tick_circle,
                                    color: AppColors.success,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      param,
                                      style: AppTextStyles.caption,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                );
              } catch (_) {
                return const SizedBox.shrink();
              }
            }),
        ],
      ),
    );
  }

  Widget _buildCollectionDeliveryCard(LabPackage pkg) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.elementGap,
      ),
      decoration: AppCardStyles.primaryGradientCard,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        children: [
          _buildRow(
            IconsaxPlusLinear.timer,
            'Collection Time',
            pkg.sampleCollectionTime,
          ),
          const Divider(height: AppSpacing.sectionGap, color: Colors.white24),
          _buildRow(
            IconsaxPlusLinear.truck_fast,
            'Report Delivery',
            pkg.reportDeliveryTime,
          ),
        ],
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
                style: AppTextStyles.description.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    LabPackage pkg,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Package', style: AppTextStyles.cardTitle),
        content: Text(
          'Are you sure you want to delete ${pkg.name}?',
          style: AppTextStyles.description,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(packageProvider.notifier).deletePackage(pkg.id);
              Navigator.pop(context);
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${pkg.name} deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
