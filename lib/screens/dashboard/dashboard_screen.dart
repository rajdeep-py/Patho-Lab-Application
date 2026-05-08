import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/dashboard_provider.dart';
import '../../cards/dashboard/count_card.dart';
import '../../cards/dashboard/booking_graph_card.dart';
import '../../cards/dashboard/earning_graph_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final data = dashboardState.data;

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: const CustomAppBar(
        title: 'Dashboard',
        subtitle: 'Overview and Analytics',
        showMenuButton: true,
      ),
      body: dashboardState.isLoading || data == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Compact Counts Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCompactCard(
                          context,
                          title: 'Lab Tests',
                          count: data.totalTests.toString(),
                          icon: IconsaxPlusLinear.document_text,
                          color: AppColors.primaryAccent,
                        ),
                        _buildCompactCard(
                          context,
                          title: 'Pending',
                          count: data.pendingBookings.toString(),
                          icon: IconsaxPlusLinear.timer_1,
                          color: AppColors.warning,
                        ),
                        _buildCompactCard(
                          context,
                          title: 'Collected',
                          count: data.sampleCollected.toString(),
                          icon: IconsaxPlusLinear.glass_1,
                          color: AppColors.secondaryCyan,
                        ),
                        _buildCompactCard(
                          context,
                          title: 'Delivered',
                          count: data.reportsDelivered.toString(),
                          icon: IconsaxPlusLinear.tick_circle,
                          color: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Graphs
                  BookingGraphCard(data: data.monthlyBookings),
                  
                  const SizedBox(height: 24),
                  
                  EarningGraphCard(data: data.monthlyEarnings),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildCompactCard(
    BuildContext context, {
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: CountCard(
        title: title,
        count: count,
        icon: icon,
        color: color,
      ),
    );
  }
}
