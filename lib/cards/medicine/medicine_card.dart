import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../models/medicine.dart';
import '../../theme/app_theme.dart';
import '../../providers/medicine_provider.dart';

class MedicineCard extends ConsumerWidget {
  final Medicine medicine;

  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppCardStyles.sleekCard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/medicine-details', extra: medicine),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Medicine Photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    medicine.photoUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.background,
                      child: const Icon(IconsaxPlusLinear.empty_wallet_tick, color: AppColors.textTertiary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medicine.description,
                        style: AppTextStyles.caption.copyWith(fontSize: 11),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${medicine.price.toStringAsFixed(2)}',
                            style: AppTextStyles.cardTitle.copyWith(
                              fontSize: 15,
                              color: AppColors.primaryAccent,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccent.withAlpha(15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Qty: ${medicine.quantity}',
                              style: AppTextStyles.tagline.copyWith(
                                fontSize: 10,
                                color: AppColors.primaryAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Remove Button
                IconButton(
                  onPressed: () {
                    _showRemoveConfirmation(context, ref);
                  },
                  icon: const Icon(IconsaxPlusLinear.trash, color: AppColors.error, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRemoveConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Medicine'),
        content: Text('Are you sure you want to remove ${medicine.name} from your inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              ref.read(medicineProvider.notifier).removeFromInventory(medicine.id);
              Navigator.pop(context);
            },
            child: const Text('REMOVE', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
