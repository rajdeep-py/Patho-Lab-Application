import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:patho_lab_panel/widgets/app_bar.dart';
import 'package:patho_lab_panel/widgets/side_nav_bar.dart';
import '../../providers/test_provider.dart';
import '../../theme/app_theme.dart';
import '../../cards/test_management/test_search_filter_card.dart';
import '../../cards/test_management/test_card.dart';

class TestManagementScreen extends ConsumerWidget {
  const TestManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(filteredTestsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Test Management',
        subtitle: 'Manage all lab tests',
        showMenuButton: true,
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.notification),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const TestSearchFilterCard()
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
              itemCount: tests.length,
              itemBuilder: (context, index) {
                return TestCard(test: tests[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
