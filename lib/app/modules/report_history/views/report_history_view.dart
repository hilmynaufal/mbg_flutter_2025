import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_history_controller.dart';
import '../../../routes/app_routes.dart';

class ReportHistoryView extends GetView<ReportHistoryController> {
  const ReportHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Laporan'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value && controller.reportIds.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Empty state
        if (controller.reportIds.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum Ada Laporan',
                  style: Get.textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Laporan yang Anda buat akan muncul di sini',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        // List of reports
        return RefreshIndicator(
          onRefresh: controller.refreshList,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.reportIds.length,
            itemBuilder: (context, index) {
              final reportId = controller.reportIds[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.description,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    'Laporan #$reportId',
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text('Klik untuk lihat detail'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // View button
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        color: Get.theme.colorScheme.primary,
                        onPressed: () {
                          Get.toNamed(
                            Routes.REPORT_DETAIL,
                            arguments: reportId,
                          );
                        },
                        tooltip: 'Lihat Detail',
                      ),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Get.theme.colorScheme.error,
                        onPressed: () => controller.deleteReport(reportId),
                        tooltip: 'Hapus',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
