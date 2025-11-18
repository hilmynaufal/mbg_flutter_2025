import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/map_viewer_widget.dart';
import '../controllers/sppg_detail_controller.dart';

class SppgDetailView extends GetView<SppgDetailController> {
  const SppgDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail SPPG'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Carousel
            _buildPhotoCarousel(),

            // Main Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Nama SPPG & Status
                  _buildHeader(),
                  const SizedBox(height: 20),

                  // Informasi Umum
                  _buildSection(
                    title: 'Informasi Umum',
                    icon: Icons.info_outline,
                    child: _buildGeneralInfo(),
                  ),
                  const SizedBox(height: 20),

                  // Kontak
                  _buildSection(
                    title: 'Kontak',
                    icon: Icons.phone_outlined,
                    child: _buildContactInfo(),
                  ),
                  const SizedBox(height: 20),

                  // Produksi
                  _buildSection(
                    title: 'Informasi Produksi',
                    icon: Icons.restaurant_outlined,
                    child: _buildProductionInfo(),
                  ),
                  const SizedBox(height: 20),

                  // Lokasi
                  _buildSection(
                    title: 'Lokasi',
                    icon: Icons.location_on_outlined,
                    child: _buildLocationInfo(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build photo carousel
  Widget _buildPhotoCarousel() {
    final photos = [
      controller.sppg.detail.fotoSppgTampakDepan,
      controller.sppg.detail.fotoSppgTampakDalam,
      controller.sppg.detail.fotoSppgTampakDapur,
    ].where((url) => url.isNotEmpty).toList();

    if (photos.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: false,
        enableInfiniteScroll: photos.length > 1,
      ),
      items: photos.asMap().entries.map((entry) {
        final index = entry.key;
        final url = entry.value;
        final labels = ['Tampak Depan', 'Tampak Dalam', 'Tampak Dapur'];

        return Stack(
          children: [
            Image.network(
              url,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  labels[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// Build header with name and status
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.sppg.detail.namaSppg,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: controller.sppg.detail.isActive
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: controller.sppg.detail.isActive
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                controller.sppg.detail.statusSppg,
                style: TextStyle(
                  fontSize: 12,
                  color: controller.sppg.detail.isActive
                      ? Colors.green[700]
                      : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                controller.sppg.detail.status.isNotEmpty
                    ? controller.sppg.detail.status
                    : 'Regular',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build section wrapper
  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  /// Build general info
  Widget _buildGeneralInfo() {
    return Column(
      children: [
        _buildInfoRow('Mitra/Yayasan', controller.sppg.detail.namaMitraAtauYayasan),
        _buildDivider(),
        _buildInfoRow('Kecamatan', controller.sppg.detail.kecamatan),
        _buildDivider(),
        _buildInfoRow('Desa', controller.sppg.detail.desa),
        _buildDivider(),
        _buildInfoRow('Alamat', controller.sppg.detail.alamatLengkapLokasi),
      ],
    );
  }

  /// Build contact info
  Widget _buildContactInfo() {
    return Column(
      children: [
        _buildMaskedInfoRow(
          'Nama Ketua',
          controller.maskedNamaKetua,
          controller.sppg.detail.namaKetuaSppg,
        ),
        _buildDivider(),
        _buildMaskedInfoRow(
          'WhatsApp Ketua',
          controller.maskedWhatsappKetua,
          '0${controller.sppg.detail.noWhatsappKetuaSppg}',
        ),
        _buildDivider(),
        _buildMaskedInfoRow(
          'Pelapor',
          controller.maskedNamaPelapor,
          controller.sppg.detail.namaLengkap,
        ),
        _buildDivider(),
        _buildMaskedInfoRow(
          'No. HP Pelapor',
          controller.maskedNoHpPelapor,
          '0${controller.sppg.detail.noHp}',
        ),
      ],
    );
  }

  /// Build production info
  Widget _buildProductionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Produksi',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${controller.sppg.detail.totalProduksi} porsi',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Suplai Makanan:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...controller.suplaiMakananList.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.chevron_right, size: 16),
                const SizedBox(width: 4),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build location info
  Widget _buildLocationInfo() {
    final coords = controller.sppg.detail.coordinateValues;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCopyableRow(
          'Koordinat',
          controller.sppg.detail.titikLokasi,
          onCopy: () => controller.copyToClipboard(
            controller.sppg.detail.titikLokasi,
            'Koordinat',
          ),
        ),
        const SizedBox(height: 12),
        if (coords != null && coords.length == 2)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: MapViewerWidget(
              latitude: coords[0],
              longitude: coords[1],
            ),
          )
        else
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('Koordinat tidak valid'),
            ),
          ),
      ],
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : '-',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  /// Build copyable row
  Widget _buildCopyableRow(String label, String value, {required VoidCallback onCopy}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : '-',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        IconButton(
          onPressed: onCopy,
          icon: const Icon(Icons.copy, size: 18),
          tooltip: 'Salin',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  /// Build masked info row with tooltip showing original value
  Widget _buildMaskedInfoRow(String label, String maskedValue, String originalValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Tooltip(
            message: 'Data disembunyikan untuk privasi',
            child: Text(
              maskedValue.isNotEmpty ? maskedValue : '-',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build divider
  Widget _buildDivider() {
    return Divider(height: 24, color: Colors.grey[300]);
  }
}
