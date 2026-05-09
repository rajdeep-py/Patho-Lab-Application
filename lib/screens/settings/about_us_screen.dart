import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/about_us_provider.dart';
import '../../cards/about_us/header_card.dart';
import '../../cards/about_us/description_card.dart';
import '../../cards/about_us/director_message_card.dart';
import '../../cards/about_us/contact_card.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutUsData = ref.watch(aboutUsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'About Us',
        subtitle: 'Learn more about us',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
        child: Column(
          children: [
            AboutHeaderCard(data: aboutUsData).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
            AboutDescriptionCard(data: aboutUsData).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),
            DirectorMessageCard(data: aboutUsData).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1),
            AboutContactCard(data: aboutUsData).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }
}
