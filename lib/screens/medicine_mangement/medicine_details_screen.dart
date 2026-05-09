import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/medicine.dart';
import '../../theme/app_theme.dart';
import '../../providers/medicine_provider.dart';
import '../../widgets/app_bar.dart';

class MedicineDetailsScreen extends ConsumerStatefulWidget {
  final Medicine medicine;

  const MedicineDetailsScreen({super.key, required this.medicine});

  @override
  ConsumerState<MedicineDetailsScreen> createState() =>
      _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends ConsumerState<MedicineDetailsScreen> {
  late TextEditingController _priceController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.medicine.price.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Medicine Details',
        subtitle: 'View and update specifications',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppCardStyles.sleekCard,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.medicine.photoUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.medicine.name,
                    style: AppTextStyles.header.copyWith(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.medicine.manufacturer,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat(
                        'Price',
                        '₹${widget.medicine.price.toStringAsFixed(2)}',
                        IconsaxPlusLinear.wallet,
                      ),
                      _buildHeaderStat(
                        'Stock',
                        widget.medicine.quantity.toString(),
                        IconsaxPlusLinear.box,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Price Update Section
            Text(
              'Update Market Price',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppCardStyles.sleekCard,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      enabled: _isEditing,
                      decoration: InputDecoration(
                        prefixText: '₹ ',
                        hintText: 'Enter new price',
                        filled: !_isEditing,
                        fillColor: _isEditing
                            ? Colors.transparent
                            : AppColors.background,
                      ),
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _isEditing
                      ? IconButton(
                          onPressed: () {
                            final newPrice = double.tryParse(
                              _priceController.text,
                            );
                            if (newPrice != null) {
                              ref
                                  .read(medicineProvider.notifier)
                                  .updatePrice(widget.medicine.id, newPrice);
                              setState(() => _isEditing = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Price updated successfully!'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(
                            IconsaxPlusLinear.tick_circle,
                            color: AppColors.success,
                          ),
                        )
                      : IconButton(
                          onPressed: () => setState(() => _isEditing = true),
                          icon: const Icon(
                            IconsaxPlusLinear.edit,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Information Sections
            _buildInfoSection('Description', widget.medicine.description),
            const SizedBox(height: 16),
            _buildInfoSection('Composition', widget.medicine.composition),
            const SizedBox(height: 16),
            _buildInfoSection(
              'Manufacturer Details',
              widget.medicine.manufacturer,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textTertiary, size: 20),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.tagline.copyWith(
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.description.copyWith(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
