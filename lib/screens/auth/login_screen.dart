import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../cards/auth/support_bottomsheet.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    await ref.read(authProvider.notifier).login(email, password);

    final authState = ref.read(authProvider);
    if (authState.error != null) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(authState.error!)));
    } else if (authState.user != null) {
      if (mounted) {
        context.go('/test-management');
      }
    }
  }

  void _showSupportBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SupportBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // Header
              const Text(
                'Welcome Back',
                style: AppTextStyles.header,
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),

              const SizedBox(height: 8),

              const Text(
                    'PLEASE LOGIN TO YOUR PATHO LAB PANEL',
                    style: AppTextStyles.tagline,
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideX(begin: -0.2, end: 0),

              const SizedBox(height: 48),

              // Form
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email Address', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'e.g. admin@patholab.com',
                          prefixIcon: Icon(
                            IconsaxPlusLinear.sms,
                            size: 20,
                            color: AppColors.secondaryCyan,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text('Password', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(
                            IconsaxPlusLinear.lock,
                            size: 20,
                            color: AppColors.secondaryCyan,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? IconsaxPlusLinear.eye_slash
                                  : IconsaxPlusLinear.eye,
                              size: 20,
                              color: AppColors.secondaryCyan,
                            ),
                            onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: 40),

              // Sign In Button
              SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      child: authState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign In'),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms)
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                  ),

              const SizedBox(height: 32),

              // Support Rich Text
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.description.copyWith(fontSize: 14),
                    children: [
                      const TextSpan(text: 'Facing trouble while logging in? '),
                      TextSpan(
                        text: 'Contact support',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _showSupportBottomSheet,
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
