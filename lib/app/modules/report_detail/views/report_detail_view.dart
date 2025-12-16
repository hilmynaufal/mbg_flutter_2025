import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/map_viewer_widget.dart';
import '../../../core/widgets/fallback_image_widget.dart';
import '../controllers/report_detail_controller.dart';

class ReportDetailView extends GetView<ReportDetailController> {
  const ReportDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Laporan #${controller.reportId}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.editReport,
            tooltip: 'Edit Laporan',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: controller.deleteReport,
            tooltip: 'Hapus Laporan',
          ),
        ],
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error state
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Get.theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Gagal Memuat Detail',
                  style: Get.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.retryLoad,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        // Data loaded
        final report = controller.reportDetail.value;
        if (report == null) {
          return const Center(child: Text('Data tidak tersedia'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  _buildInfoRow(
                    'ID Laporan',
                    '#${report.id}',
                    Icons.tag,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Tanggal Submit',
                    report.submittedAt,
                    Icons.calendar_today,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Submitted By',
                    report.submittedBy,
                    Icons.person,
                  ),
                  if (report.skpdNama != null) ...[
                    const Divider(height: 24),
                    _buildInfoRow(
                      'SKPD',
                      report.skpdNama!,
                      Icons.business,
                    ),
                  ],

                  // Add divider before answers if there are any
                  if (report.answers.isNotEmpty) const Divider(height: 24),

                  // All Answers (Q&A)
                  ...() {
                    log('Rendering ${report.answers.length} answers');
                    return report.answers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final qa = entry.value;
                      final isLast = index == report.answers.length - 1;
                      log('Rendering answer #$index: ${qa.question}');

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Determine answer type and render accordingly
                          if (qa.isCoordinate && qa.coordinateValues != null)
                            // Coordinate answer with map
                            _buildMapAnswerRow(qa)
                          else if (qa.isImageUrl)
                            // Image answer
                            _buildImageAnswerRow(qa)
                          else
                            // Text answer
                            _buildAnswerRow(qa),

                          // Divider (except for last item)
                          if (!isLast) const Divider(height: 24),
                        ],
                      );
                    });
                  }(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Get.theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build answer row for text-based answers
  Widget _buildAnswerRow(dynamic qa) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.help_outline,
          size: 20,
          color: Get.theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                qa.question,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                qa.answer.isEmpty ? '-' : qa.answer,
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build answer row for coordinate answers with map display
  Widget _buildMapAnswerRow(dynamic qa) {
    final coords = qa.coordinateValues!;
    final lat = coords['latitude']!;
    final lng = coords['longitude']!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on,
          size: 20,
          color: Get.theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                qa.question,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                qa.answer,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              // Map viewer
              MapViewerWidget(
                latitude: lat,
                longitude: lng,
                height: 200,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build answer row for image answers
  Widget _buildImageAnswerRow(dynamic qa) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.image,
          size: 20,
          color: Get.theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                qa.question,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              // Use getImageUrl to prefer signed URL from list over unsigned URL from viewForm
              _buildImageAnswer(
                controller.getImageUrl(qa.question) ?? qa.answer,
                qa.question,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageAnswer(String imageUrl, String questionText) {
    // Only use Obx for pelaporan-penerima-mbg to avoid "improper use of getx" error
    if (controller.reportSlug == 'pelaporan-penerima-mbg') {
      // Wrap in Obx to ensure reactivity to fallbackImages changes
      return Obx(() {
        // Get fallback URL if available
        String? fallbackUrl;

        if (controller.fallbackImages.value != null) {
          final questionLower = questionText.toLowerCase();

          // Determine which fallback URL to use based on question text
          if (questionLower.contains('dokumentasi_foto') ||
              questionLower.contains('dokumentasi foto')) {
            if (questionLower.contains('1')) {
              log('controller.fallbackImages.value?.dokumentasiFoto1Url: ${controller.fallbackImages.value?.dokumentasiFoto1Url}');
              fallbackUrl =
                  controller.fallbackImages.value?.dokumentasiFoto1Url;
            } else if (questionLower.contains('2')) {
              log('controller.fallbackImages.value?.dokumentasiFoto2Url: ${controller.fallbackImages.value?.dokumentasiFoto2Url}');
              fallbackUrl =
                  controller.fallbackImages.value?.dokumentasiFoto2Url;
            } else if (questionLower.contains('3')) {
              log('controller.fallbackImages.value?.dokumentasiFoto3Url: ${controller.fallbackImages.value?.dokumentasiFoto3Url}');
              fallbackUrl =
                  controller.fallbackImages.value?.dokumentasiFoto3Url;
            }
          }
        }

        return _buildImageWidget(imageUrl, fallbackUrl);
      });
    } else {
      // For other report types, no fallback needed, no Obx needed
      return _buildImageWidget(imageUrl, null);
    }
  }

  /// Build image widget (reusable for both Obx and non-Obx cases)
  Widget _buildImageWidget(String imageUrl, String? fallbackUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => _showFullScreenImage(imageUrl, fallbackUrl),
            child: FallbackImageWidget(
              primaryUrl: imageUrl,
              fallbackUrl: fallbackUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap untuk melihat ukuran penuh',
          style: Get.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  void _showFullScreenImage(String primaryUrl, String? fallbackUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black87,
        insetPadding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            // Full screen image with fallback support
            Center(
              child: InteractiveViewer(
                child: FallbackImageWidget(
                  primaryUrl: primaryUrl,
                  fallbackUrl: fallbackUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Close button
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
