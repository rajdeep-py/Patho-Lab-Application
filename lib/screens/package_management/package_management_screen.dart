import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/package_provider.dart';
import '../../theme/app_theme.dart';
import '../../cards/package/package_search_card.dart';
import '../../cards/package/package_card.dart';
import '../../widgets/side_nav_bar.dart';

class PackageManagementScreen extends ConsumerWidget {
  const PackageManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(filteredPackagesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Package Management', style: AppTextStyles.header.copyWith(fontSize: 20)),
            Text('Manage health packages', style: AppTextStyles.caption),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/create-package');
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const PackageSearchCard(),
          Expanded(
            child: packages.isEmpty
                ? const Center(
                    child: Text('No packages found', style: AppTextStyles.description),
                  )
                : ListView.builder(
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      return PackageCard(labPackage: packages[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
