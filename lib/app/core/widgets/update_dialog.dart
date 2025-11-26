import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../data/models/version_check_response_model.dart';

class UpdateDialog extends StatelessWidget {
  final VersionData versionData;
  final bool isForceUpdate;

  const UpdateDialog({
    super.key,
    required this.versionData,
    required this.isForceUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent dialog dismissal if force update
      canPop: !isForceUpdate,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              isForceUpdate ? Icons.warning : Icons.info_outline,
              color: isForceUpdate ? Colors.orange : AppColors.primary,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isForceUpdate ? 'Update Diperlukan' : 'Update Tersedia',
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Version info
            Container(
              padding: const EdgeInsets.all(12),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Versi Terbaru:',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        versionData.latestVersion,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  if (versionData.currentVersion != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Versi Anda:',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          versionData.currentVersion!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Update message
            Text(
              versionData.updateMessage ??
                  (isForceUpdate
                      ? 'Versi aplikasi Anda sudah tidak didukung. Silakan update ke versi terbaru untuk melanjutkan.'
                      : 'Versi baru telah tersedia dengan fitur dan perbaikan terbaru. Segera update aplikasi Anda!'),
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          // "Nanti" button (only for optional update)
          if (!isForceUpdate)
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Nanti',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),

          // "Update Sekarang" button
          ElevatedButton(
            onPressed: _openStore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Update Sekarang',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Open app store based on platform
  void _openStore() async {
    try {
      String url;

      if (Platform.isAndroid) {
        url = versionData.downloadUrl.android;
      } else if (Platform.isIOS) {
        url = versionData.downloadUrl.ios;
      } else {
        Get.snackbar(
          'Platform Tidak Didukung',
          'Update hanya tersedia untuk Android dan iOS',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (url.isEmpty) {
        Get.snackbar(
          'URL Tidak Tersedia',
          'Link download untuk platform ini tidak tersedia',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar(
          'Gagal Membuka Store',
          'Tidak dapat membuka App Store',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Show update dialog
  static void show({
    required VersionData versionData,
    required bool isForceUpdate,
  }) {
    Get.dialog(
      UpdateDialog(
        versionData: versionData,
        isForceUpdate: isForceUpdate,
      ),
      barrierDismissible: !isForceUpdate, // Cannot dismiss if force update
    );
  }
}
