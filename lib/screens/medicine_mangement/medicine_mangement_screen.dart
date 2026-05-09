import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/medicine_provider.dart';
import '../../cards/medicine/medicine_card.dart';
import '../../cards/medicine/medicine_search_filter_card.dart';

class MedicineManagementScreen extends ConsumerWidget {
  const MedicineManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineProvider);
    final filteredInventory = medicineState.filteredInventory;

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Medicine Management',
        subtitle: 'Manage your clinical inventory',
        showMenuButton: true,
        actions: [
          IconButton(
            onPressed: () => context.push('/add-medicine-inventory'),
            icon: const Icon(IconsaxPlusLinear.add_square, color: AppColors.primaryAccent),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MedicineSearchFilterCard(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inventory List',
                  style: AppTextStyles.subHeader.copyWith(fontSize: 18),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withAlpha(15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${filteredInventory.length} Items',
                    style: AppTextStyles.tagline.copyWith(
                      fontSize: 10,
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (filteredInventory.isEmpty)
              _buildEmptyState()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredInventory.length,
                itemBuilder: (context, index) {
                  return MedicineCard(medicine: filteredInventory[index]);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Opacity(
            opacity: 0.3,
            child: Icon(
              IconsaxPlusLinear.box_search,
              size: 80,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No medicines found in your inventory',
            style: AppTextStyles.description,
          ),
          const SizedBox(height: 12),
          Text(
            'Try adjusting your filters or add new medicines',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
