import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/form_success_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';

class FormSuccessView extends GetView<FormSuccessController> {
  const FormSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Berhasil'),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Success Icon with Animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Success Title
            Text(
              'Laporan Berhasil Dikirim!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Laporan Anda telah berhasil tersimpan dan akan segera diproses',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Report Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.primary, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Report ID
                    _buildInfoRow(
                      context,
                      icon: Icons.tag,
                      label: 'ID Laporan',
                      value: '#${controller.reportData.id}',
                      isBold: true,
                      onCopy: () => controller.copyToClipboard(
                        controller.reportData.id.toString(),
                        'ID Laporan',
                      ),
                    ),

                    const Divider(height: 24),

                    // Token
                    _buildInfoRow(
                      context,
                      icon: Icons.vpn_key,
                      label: 'Token Laporan',
                      value: controller.reportData.token,
                      onCopy: () => controller.copyToClipboard(
                        controller.reportData.token,
                        'Token',
                      ),
                    ),

                    const Divider(height: 24),

                    // Submission Date
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Tanggal Submit',
                      value: _formatDateTime(controller.reportData.submittedAt),
                    ),

                    // SKPD (if available)
                    if (controller.reportData.skpdNama != null) ...[
                      const Divider(height: 24),
                      _buildInfoRow(
                        context,
                        icon: Icons.business,
                        label: 'SKPD',
                        value: controller.reportData.skpdNama!,
                      ),
                    ],

                    // Description (if not empty)
                    if (controller.reportData.description.isNotEmpty) ...[
                      const Divider(height: 24),
                      _buildInfoRow(
                        context,
                        icon: Icons.description,
                        label: 'Deskripsi',
                        value: controller.reportData.description,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  // Primary Action: View Report Detail
                  GradientButton(
                    text: 'Lihat Detail Laporan',
                    onPressed: controller.viewReportDetail,
                    icon: Icons.visibility,
                    height: 50,
                  ),

                  const SizedBox(height: 12),

                  // Secondary Action: Create Another Report
                  OutlinedButton.icon(
                    onPressed: controller.createAnotherReport,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Buat Laporan Lagi'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: AppColors.primary, width: 2),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tertiary Action: Back to Home
                  TextButton.icon(
                    onPressed: controller.backToHome,
                    icon: const Icon(Icons.home),
                    label: const Text('Kembali ke Home'),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Build info row with icon, label, and value
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isBold = false,
    VoidCallback? onCopy,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 12),

        // Label & Value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                      fontSize: isBold ? 18 : null,
                    ),
              ),
            ],
          ),
        ),

        // Copy Button (if onCopy provided)
        if (onCopy != null)
          IconButton(
            onPressed: onCopy,
            icon: const Icon(Icons.copy, size: 20),
            tooltip: 'Salin',
            style: IconButton.styleFrom(
              foregroundColor: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
      ],
    );
  }

  /// Format DateTime string to readable format
  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final formatter = DateFormat('d MMMM yyyy, HH:mm', 'id_ID');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}
