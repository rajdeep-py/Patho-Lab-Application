import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:patho_lab_panel/widgets/app_bar.dart';
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
      appBar: CustomAppBar(
        title: 'Package Management',
        subtitle: 'Manage health packages',
        showMenuButton: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/create-package');
              },
              icon: const Icon(IconsaxPlusLinear.add, size: 18),
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
          const PackageSearchCard().animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),
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
