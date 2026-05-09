import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/terms_conditions_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../cards/terms_conditions/terms_conditions_card.dart';

class TermsConditionsScreen extends ConsumerWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsConditions = ref.watch(termsConditionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Terms & Conditions',
        subtitle: 'Read our terms and guidelines',
        showBackButton: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: termsConditions.length,
        itemBuilder: (context, index) {
          return TermsConditionsCard(
            termsCondition: termsConditions[index],
          ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideY(begin: 0.1);
        },
      ),
    );
  }
}
