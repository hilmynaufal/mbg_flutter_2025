import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';
import '../controllers/posyandu_edit_controller.dart';
import 'widgets/posyandu_card.dart';

class PosyanduEditView extends GetView<PosyanduEditController> {
  const PosyanduEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.menuTitle),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Loading indicator (if loading)
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Memuat data posyandu...',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Instruction card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Cari Data Posyandu',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Masukkan nomor HP pelapor yang terdaftar untuk mencari dan melihat daftar posyandu Anda.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Phone input field
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor HP Pelapor',
                hintText: 'Contoh: 081234567890',
                prefixIcon: const Icon(Icons.phone),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              onSubmitted: (_) => controller.searchByPhone(),
            ),
            const SizedBox(height: 16),

            // Search button
            Obx(() => GradientButton(
                  text: 'Cari Posyandu',
                  onPressed: controller.searchByPhone,
                  isLoading: controller.isSearching.value,
                  icon: Icons.search,
                )),

            const SizedBox(height: 24),

            // Search results section
            Expanded(
              child: Obx(() {
                if (!controller.hasSearched.value) {
                  // Show help info before search
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Masukkan nomor HP pelapor dan klik "Cari Posyandu" untuk melihat daftar posyandu yang terdaftar',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredPosyanduList.isEmpty) {
                  // Empty state - no results found
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada hasil',
                          style: AppTextStyles.h4.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ditemukan posyandu dengan\nnomor HP yang Anda cari',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Show search results
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Results header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      child: Text(
                        'Ditemukan ${controller.filteredPosyanduList.length} Posyandu',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Results list
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.filteredPosyanduList.length,
                        itemBuilder: (context, index) {
                          final posyandu = controller.filteredPosyanduList[index];
                          return PosyanduCard(
                            posyandu: posyandu,
                            onTap: () => controller.navigateToDetail(posyandu),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
