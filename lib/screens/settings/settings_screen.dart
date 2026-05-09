import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/settings/settings_card.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const SideNavBar(),
      appBar: const CustomAppBar(
        title: 'Settings',
        subtitle: 'Manage your preferences',
        showMenuButton: true,
      ),
      body: settingsState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                const Text(
                  'General',
                  style: AppTextStyles.cardTitle,
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                const SizedBox(height: AppSpacing.elementGap),
                SettingsCard(
                  optionName: 'About Us',
                  tagline: 'Learn more about Patho Lab',
                  icon: IconsaxPlusLinear.info_circle,
                  onTap: () {
                    context.push('/about-us');
                  },
                ).animate().fadeIn(duration: 400.ms, delay: 50.ms).slideY(begin: 0.1),
                SettingsCard(
                  optionName: 'Terms and Conditions',
                  tagline: 'Read our terms of service',
                  icon: IconsaxPlusLinear.document_text_1,
                  onTap: () {
                    context.push('/terms-conditions');
                  },
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),
                SettingsCard(
                  optionName: 'Privacy and Policy',
                  tagline: 'How we handle your data',
                  icon: IconsaxPlusLinear.shield_tick,
                  onTap: () {
                    context.push('/privacy-policy');
                  },
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1),
                
                const SizedBox(height: AppSpacing.sectionGap),
                
                const Text(
                  'Support & Feedback',
                  style: AppTextStyles.cardTitle,
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -0.1),
                const SizedBox(height: AppSpacing.elementGap),
                SettingsCard(
                  optionName: 'Raise an Issue',
                  tagline: 'Report a bug or problem',
                  icon: IconsaxPlusLinear.message_question,
                  onTap: () {},
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms).slideY(begin: 0.1),
                SettingsCard(
                  optionName: 'Give Feedback',
                  tagline: 'Help us improve',
                  icon: IconsaxPlusLinear.like_1,
                  onTap: () {},
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1),

                const SizedBox(height: AppSpacing.sectionGap),

                const Text(
                  'Account Management',
                  style: AppTextStyles.cardTitle,
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms).slideX(begin: -0.1),
                const SizedBox(height: AppSpacing.elementGap),
                SettingsCard(
                  optionName: 'Log Out',
                  tagline: 'Sign out of your account',
                  icon: IconsaxPlusLinear.logout,
                  isDestructive: true,
                  onTap: () => _handleLogout(context, ref),
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.1),
                SettingsCard(
                  optionName: 'Delete Account',
                  tagline: 'Permanently remove your data',
                  icon: IconsaxPlusLinear.trash,
                  isDestructive: true,
                  onTap: () => _handleDeleteAccount(context, ref),
                ).animate().fadeIn(duration: 400.ms, delay: 450.ms).slideY(begin: 0.1),
                
                const SizedBox(height: AppSpacing.sectionGap),
              ],
            ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out', style: AppTextStyles.cardTitle),
        content: const Text('Are you sure you want to log out?', style: AppTextStyles.description),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cardRadius)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await ref.read(settingsProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account', style: AppTextStyles.cardTitle),
        content: const Text(
            'This action is permanent and cannot be undone. All your data will be erased.',
            style: AppTextStyles.description),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cardRadius)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await ref.read(settingsProvider.notifier).deleteAccount();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }
}
