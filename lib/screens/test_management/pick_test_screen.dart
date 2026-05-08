import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/test_provider.dart';
import '../../cards/test_management/pick_test_search_card.dart';
import '../../cards/test_management/pick_test_card.dart';

class PickTestScreen extends ConsumerStatefulWidget {
  const PickTestScreen({super.key});

  @override
  ConsumerState<PickTestScreen> createState() => _PickTestScreenState();
}

class _PickTestScreenState extends ConsumerState<PickTestScreen> {
  final List<LabTest> _selectedTests = [];

  void _toggleSelection(LabTest test) {
    setState(() {
      if (_selectedTests.any((t) => t.id == test.id)) {
        _selectedTests.removeWhere((t) => t.id == test.id);
      } else {
        _selectedTests.add(test);
      }
    });
  }

  void _addToInventory() {
    if (_selectedTests.isEmpty) return;
    
    ref.read(testProvider.notifier).addToInventory(_selectedTests);
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedTests.length} tests added to your inventory'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredAvailable = ref.watch(testProvider.notifier).filteredAvailableTests;
    final inventoryIds = ref.watch(testProvider).inventory.map((t) => t.id).toSet();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'Select Tests',
        subtitle: 'Global Master Catalog',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Background Decor
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(15),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                child: const PickTestSearchCard(),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    100,
                  ),
                  itemCount: filteredAvailable.length,
                  itemBuilder: (context, index) {
                    final test = filteredAvailable[index];
                    final isAlreadyInInventory = inventoryIds.contains(test.id);
                    
                    return PickTestCard(
                      test: test,
                      isSelected: _selectedTests.any((t) => t.id == test.id) || isAlreadyInInventory,
                      onTap: isAlreadyInInventory ? () {} : () => _toggleSelection(test),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: _selectedTests.isNotEmpty ? _buildSelectionSummaryBar() : null,
    );
  }

  Widget _buildSelectionSummaryBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(IconsaxPlusLinear.tick_square, color: AppColors.primaryAccent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_selectedTests.length} Tests Selected', style: AppTextStyles.cardTitle),
                      Text('Ready to add to your lab inventory', style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addToInventory,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                shadowColor: AppColors.primaryAccent.withAlpha(100),
              ),
              child: const Text(
                'Add to Inventory Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
