import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CountCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const CountCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppCardStyles.sleekCard,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: AppTextStyles.header.copyWith(
                    fontSize: 18, 
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 9, 
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
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
}
