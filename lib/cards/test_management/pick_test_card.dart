import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/test.dart';
import '../../theme/app_theme.dart';

class PickTestCard extends StatelessWidget {
  final LabTest test;
  final bool isSelected;
  final VoidCallback onTap;

  const PickTestCard({
    super.key,
    required this.test,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(15) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider.withAlpha(128),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppColors.primary.withAlpha(40) 
                  : const Color(0xFF000000).withAlpha(10),
              blurRadius: isSelected ? 20 : 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Premium Thumbnail
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      test.photoUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.name,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 17, height: 1.2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        test.category,
                        style: AppTextStyles.tagline.copyWith(fontSize: 10, color: AppColors.secondaryCyan),
                      ),
                    ],
                  ),
                ),
                // Selection Indicator
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isSelected ? IconsaxPlusBold.tick_circle : IconsaxPlusLinear.add_circle,
                    key: ValueKey(isSelected),
                    color: isSelected ? AppColors.primaryAccent : AppColors.textTertiary,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description with stylish typography
            Text(
              test.description,
              style: AppTextStyles.description.copyWith(fontSize: 13, color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            // Parameters Horizontal List
            SizedBox(
              height: 32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: test.parameters.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider.withAlpha(100)),
                    ),
                    child: Center(
                      child: Text(
                        test.parameters[index],
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Precautions Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(IconsaxPlusLinear.warning_2, size: 16, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      test.precautions,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.warning,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
