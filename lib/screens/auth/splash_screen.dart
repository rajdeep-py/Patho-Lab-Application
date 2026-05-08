import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/logo/logo.png', width: 120, height: 120)
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      curve: Curves.easeOutBack,
                    ),

                const SizedBox(height: 24),

                // App Name
                const Text('MedApp', style: AppTextStyles.header)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 8),

                // Tagline
                const Text(
                      'YOUR PERSONAL HEALTH PARTNER',
                      style: AppTextStyles.tagline,
                    )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideY(begin: 0.5, end: 0),
              ],
            ),
          ),

          // Bottom Text
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: const Text(
                'Powered by Naiyo24',
                style: AppTextStyles.caption,
              ).animate().fadeIn(delay: 1200.ms, duration: 800.ms),
            ),
          ),
        ],
      ),
    );
  }
}
