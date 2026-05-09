import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/privacy_policy_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../cards/privacy_policy/privacy_policy_card.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policies = ref.watch(privacyPolicyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Privacy Policy',
        subtitle: 'How we protect your data',
        showBackButton: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: policies.length,
        itemBuilder: (context, index) {
          return PrivacyPolicyCard(
            privacyPolicy: policies[index],
          ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideY(begin: 0.1);
        },
      ),
    );
  }
}
