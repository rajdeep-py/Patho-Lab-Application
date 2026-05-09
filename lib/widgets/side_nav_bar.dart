import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';

class SideNavBar extends ConsumerWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final currentPath = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: AppColors.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSpacing.borderRadius),
          bottomRight: Radius.circular(AppSpacing.borderRadius),
        ),
      ),
      child: Column(
        children: [
          // Header Section
          _buildHeader(user),

          const SizedBox(height: 20),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _NavTile(
                  icon: IconsaxPlusLinear.category,
                  label: 'Dashboard & Analytics',
                  onTap: () => _navigateTo(context, '/dashboard'),
                  isSelected: currentPath == '/dashboard',
                ),
                _NavTile(
                  icon: IconsaxPlusLinear.document_text,
                  label: 'Tests Management',
                  onTap: () => _navigateTo(context, '/test-management'),
                  isSelected: currentPath == '/test-management',
                ),
                _NavTile(
                  icon: IconsaxPlusLinear.box,
                  label: 'Package Management',
                  onTap: () => _navigateTo(context, '/package-management'),
                  isSelected: currentPath == '/package-management',
                ),
                _NavTile(
                  icon: IconsaxPlusLinear.calendar_tick,
                  label: 'Order Management',
                  onTap: () => _navigateTo(context, '/bookings'),
                  isSelected: currentPath == '/bookings',
                ),
                _NavTile(
                  icon: IconsaxPlusLinear.wallet_3,
                  label: 'Payments & Earnings',
                  onTap: () => _navigateTo(context, '/payments'),
                  isSelected: currentPath == '/payments',
                ),
                _NavTile(
                  icon: IconsaxPlusLinear.health,
                  label: 'Medicine Management',
                  onTap: () => _navigateTo(context, '/medicine-management'),
                  isSelected: currentPath == '/medicine-management',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: AppColors.divider),
                ),
                _NavTile(
                  icon: IconsaxPlusLinear.user,
                  label: 'Profile',
                  onTap: () => _navigateTo(context, '/profile'),
                  isSelected: currentPath == '/profile',
                ),
                _NavTile(
                  icon: IconsaxPlusLinear.setting_2,
                  label: 'Settings',
                  onTap: () => _navigateTo(context, '/settings'),
                  isSelected: currentPath == '/settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(AppSpacing.borderRadius),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryAccent],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(50),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              IconsaxPlusLinear.user,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Guest User',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user?.email ?? 'Patho Lab Admin',
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer
    context.go(route);
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withAlpha(25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontFamily: 'Lexend',
                  fontSize: 15,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
