import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';
import '../controllers/bedas_menanam_detail_controller.dart';

class BedasMenanamDetailView extends GetView<BedasMenanamDetailController> {
  const BedasMenanamDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final item = controller.item;
    final detail = item.detail;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Bedas Menanam'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            FontAwesomeIcons.seedling,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.namaLengkapPelapor,
                                style: AppTextStyles.h3.copyWith(
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Informasi Pelapor section
            _buildSectionTitle('Informasi Pelapor'),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.person,
                      'Nama Pelapor',
                      detail.namaLengkapPelapor,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.phone,
                      'WhatsApp Pelapor',
                      detail.formattedWhatsapp,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.group,
                      'Kelompok Pelapor',
                      detail.kelompokPelapor,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Tanggal Lapor',
                      item.createdAt,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Informasi Lokasi section
            _buildSectionTitle('Informasi Lokasi'),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.location_city,
                      'Kecamatan',
                      detail.kecamatan,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.location_on,
                      'Desa',
                      detail.desa,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.home,
                      'RT / RW',
                      'RT ${detail.rt} / RW ${detail.rw}',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.map,
                      'Lokasi Taman',
                      detail.lokasiTaman,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Informasi Penanaman section
            _buildSectionTitle('Informasi Penanaman'),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.category,
                      'Jenis Pangan',
                      detail.jenisPangan,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.square_foot,
                      'Luas Lahan (m²)',
                      detail.luasLahanYangTersediaMeterPersegi.toString(),
                    ),
                    if (detail.jenisSayuranYangInginDitanam.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.grass,
                        'Jenis Sayuran',
                        detail.jenisSayuranYangInginDitanam,
                      ),
                    ],
                    if (detail.jenisHewanYangInginDibudidayakan.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.pets,
                        'Jenis Hewan',
                        detail.jenisHewanYangInginDibudidayakan,
                      ),
                    ],
                    if (detail.jenisIkanYangInginDibudidayakan.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.water,
                        'Jenis Ikan',
                        detail.jenisIkanYangInginDibudidayakan,
                      ),
                    ],
                    if (detail.jikaSayuranLainnyaSebutkan.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.info,
                        'Sayuran Lainnya',
                        detail.jikaSayuranLainnyaSebutkan,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data Lainnya section
            _buildSectionTitle('Data Lainnya'),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.person,
                      'Nama Lengkap',
                      detail.namaLengkap,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.phone_android,
                      'Nomor WhatsApp',
                      detail.formattedNomorWhatsapp,
                    ),
                    if (detail.catatanKeterangan.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.notes,
                        'Catatan / Keterangan',
                        detail.catatanKeterangan,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Show photo if available
            if (detail.fotoLahanYangAkanDigunakan.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('Foto Lahan'),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  detail.fotoLahanYangAkanDigunakan,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.broken_image, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Gagal memuat foto',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Edit button
            GradientButton(
              text: 'Edit Data',
              onPressed: controller.editItem,
              icon: Icons.edit,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h4.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isNotEmpty ? value : '-',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
