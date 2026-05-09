import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/package.dart';
import '../../providers/package_provider.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

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
      appBar: CustomAppBar(
        title: 'Package Details',
        showBackButton: true,
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
              tag: 'package_image_${pkg.id}',
              child: Container(
                decoration: BoxDecoration(
                  image: _getDecorationImage(pkg.photoUrl),
                  color: AppColors.darkCyan,
                ),
                child: _getDecorationImage(pkg.photoUrl) == null
                    ? const Icon(
                        IconsaxPlusLinear.box,
                        color: Colors.white54,
                        size: 50,
                      )
                    : null,
              ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryCyan.withAlpha(80),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondaryCyan.withAlpha(100)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(IconsaxPlusLinear.health, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${pkg.labTestIds.length} TESTS INCLUDED',
                          style: AppTextStyles.tagline.copyWith(color: Colors.white, fontSize: 10, letterSpacing: 1.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pkg.name,
                    style: AppTextStyles.header.copyWith(fontSize: 28, color: Colors.white, height: 1.1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${pkg.price.toStringAsFixed(2)}',
                    style: AppTextStyles.subHeader.copyWith(
                      color: AppColors.primary,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
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
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1);
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
    ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1);
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
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1);
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
