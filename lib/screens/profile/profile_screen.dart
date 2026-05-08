import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _regNoController;
  late TextEditingController _licNoController;
  late TextEditingController _phoneController;
  late TextEditingController _altPhoneController;
  late TextEditingController _passwordController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(profileProvider).user;
    _nameController = TextEditingController(text: user?.name);
    _addressController = TextEditingController(text: user?.address);
    _regNoController = TextEditingController(text: user?.registrationNo);
    _licNoController = TextEditingController(text: user?.licenseNo);
    _phoneController = TextEditingController(text: user?.phone);
    _altPhoneController = TextEditingController(text: user?.alternativePhone);
    _passwordController = TextEditingController(text: user?.password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _regNoController.dispose();
    _licNoController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final currentUser = ref.read(profileProvider).user!;
    final updatedUser = currentUser.copyWith(
      name: _nameController.text,
      address: _addressController.text,
      registrationNo: _regNoController.text,
      licenseNo: _licNoController.text,
      phone: _phoneController.text,
      alternativePhone: _altPhoneController.text,
      password: _passwordController.text,
    );
    ref.read(profileProvider.notifier).updateProfile(updatedUser);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final user = profileState.user;
    final isEditing = profileState.isEditing;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: CustomAppBar(
        title: 'Lab Profile',
        subtitle: 'Manage your establishment details',
        showMenuButton: true,
        actions: [
          IconButton(
            onPressed: () {
              if (isEditing) {
                _saveProfile();
              } else {
                ref.read(profileProvider.notifier).toggleEdit();
              }
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isEditing ? AppColors.success : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Icon(
                isEditing
                    ? IconsaxPlusLinear.tick_circle
                    : IconsaxPlusLinear.edit_2,
                size: 20,
                color: isEditing ? Colors.white : AppColors.primaryAccent,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            // Avatar Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(50),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: AppColors.background,
                      backgroundImage: user.profileImage != null
                          ? NetworkImage(user.profileImage!)
                          : null,
                      child: user.profileImage == null
                          ? const Icon(IconsaxPlusLinear.user, size: 40)
                          : null,
                    ),
                  ),
                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          IconsaxPlusLinear.camera,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(user.name, style: AppTextStyles.header.copyWith(fontSize: 24)),
            Text(
              user.email,
              style: AppTextStyles.tagline.copyWith(
                color: AppColors.textTertiary,
              ),
            ),

            const SizedBox(height: 32),

            // Details Section
            _buildSectionHeader('General Information'),
            _buildProfileField(
              label: 'Patho Lab Name',
              controller: _nameController,
              icon: IconsaxPlusLinear.hospital,
              isEditing: isEditing,
            ),
            _buildProfileField(
              label: 'Establishment Address',
              controller: _addressController,
              icon: IconsaxPlusLinear.location,
              isEditing: isEditing,
              maxLines: 3,
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Legal & Registration'),
            Row(
              children: [
                Expanded(
                  child: _buildProfileField(
                    label: 'Reg. No',
                    controller: _regNoController,
                    icon: IconsaxPlusLinear.document_text_1,
                    isEditing: isEditing,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProfileField(
                    label: 'License No',
                    controller: _licNoController,
                    icon: IconsaxPlusLinear.shield_tick,
                    isEditing: isEditing,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Contact Details'),
            _buildProfileField(
              label: 'Primary Phone',
              controller: _phoneController,
              icon: IconsaxPlusLinear.call,
              isEditing: isEditing,
              keyboardType: TextInputType.phone,
            ),
            _buildProfileField(
              label: 'Alternative Phone',
              controller: _altPhoneController,
              icon: IconsaxPlusLinear.call_calling,
              isEditing: isEditing,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Security'),
            _buildProfileField(
              label: 'Account Password',
              controller: _passwordController,
              icon: IconsaxPlusLinear.lock,
              isEditing: isEditing,
              isPassword: true,
              isPasswordVisible: _isPasswordVisible,
              onTogglePassword: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),

            const SizedBox(height: 40),
            if (isEditing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: profileState.isLoading ? null : _saveProfile,
                  child: profileState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Update Profile Details'),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.tagline.copyWith(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditing,
    int maxLines = 1,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryAccent),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isEditing)
            TextField(
              controller: controller,
              maxLines: maxLines,
              obscureText: isPassword && !isPasswordVisible,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? IconsaxPlusLinear.eye_slash
                              : IconsaxPlusLinear.eye,
                          size: 20,
                        ),
                        onPressed: onTogglePassword,
                      )
                    : null,
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider.withAlpha(100)),
              ),
              child: Text(
                isPassword ? '•' * controller.text.length : controller.text,
                style: AppTextStyles.description.copyWith(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
