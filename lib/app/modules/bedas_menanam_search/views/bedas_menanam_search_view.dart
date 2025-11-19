import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../data/regional_data.dart';
import '../controllers/bedas_menanam_search_controller.dart';

class BedasMenanamSearchView extends GetView<BedasMenanamSearchController> {
  const BedasMenanamSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.menuTitle),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.clearFilters,
            tooltip: 'Reset Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search filters section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                          Icon(Icons.search, color: AppColors.primary, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Cari Data Bedas Menanam',
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilih Kecamatan dan Desa, lalu masukkan nomor WhatsApp untuk mencari data.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Kecamatan dropdown
                Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Kecamatan *',
                        prefixIcon: const Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      value: controller.selectedKecamatan.value?.nmKec,
                      items: RegionalData.kecamatanList
                          .map((kec) => DropdownMenuItem(
                                value: kec.nmKec,
                                child: Text(kec.nmKec),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final kec = RegionalData.kecamatanList
                            .firstWhereOrNull((k) => k.nmKec == value);
                        controller.onKecamatanChanged(kec);
                      },
                    )),
                const SizedBox(height: 12),

                // Desa dropdown (enabled only when kecamatan is selected)
                Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Desa *',
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      value: controller.selectedDesa.value?.nmDesa,
                      items: controller.availableDesaList
                          .map((desa) => DropdownMenuItem(
                                value: desa.nmDesa,
                                child: Text(desa.nmDesa),
                              ))
                          .toList(),
                      onChanged: controller.selectedKecamatan.value == null
                          ? null
                          : (value) {
                              final desa = controller.availableDesaList
                                  .firstWhereOrNull((d) => d.nmDesa == value);
                              controller.onDesaChanged(desa);
                            },
                    )),
                const SizedBox(height: 12),

                // Phone search field
                TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Nomor WhatsApp Pelapor',
                    hintText: 'Contoh: 085155029599',
                    prefixIcon: const Icon(Icons.phone),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => controller.phoneController.clear(),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (_) => controller.searchByPhone(),
                ),
                const SizedBox(height: 12),

                // Search by phone button
                Obx(() => GradientButton(
                      text: 'Cari Berdasarkan WhatsApp',
                      onPressed: controller.searchByPhone,
                      isLoading: controller.isSearching.value,
                      icon: Icons.phone,
                    )),
              ],
            ),
          ),

          // Results section
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.filteredList.isEmpty) {
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
                        'Belum ada hasil pencarian',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilih Kecamatan dan Desa untuk memulai',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Results list
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Result count header
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[100],
                    child: Text(
                      'Ditemukan ${controller.filteredList.length} data',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // List view
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.filteredList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = controller.filteredList[index];
                        return _buildResultCard(item);
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(item) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: () => controller.navigateToDetail(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      FontAwesomeIcons.seedling,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.detail.namaLengkapPelapor,
                          style: AppTextStyles.h4.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${item.id}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on,
                  '${item.detail.kecamatan} - ${item.detail.desa}'),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.phone, item.detail.formattedWhatsapp),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.category, item.detail.jenisPangan),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall,
          ),
        ),
      ],
    );
  }
}
