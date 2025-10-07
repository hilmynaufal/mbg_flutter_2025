import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/providers/form_provider.dart';
import '../../../core/values/constants.dart';

class ReportHistoryController extends GetxController {
  final FormProvider _formProvider = FormProvider();
  final StorageService _storage = Get.find<StorageService>();

  // Observable states
  final RxList<int> reportIds = <int>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReportIds();
  }

  /// Load report IDs from local storage
  void loadReportIds() {
    isLoading.value = true;

    final ids = _storage.readIntList(AppConstants.keyReportIds) ?? [];
    reportIds.value = ids.reversed.toList(); // Show newest first

    isLoading.value = false;
  }

  /// Refresh list - reload from storage
  Future<void> refreshList() async {
    loadReportIds();
  }

  /// Delete report with confirmation
  Future<void> deleteReport(int id) async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus Laporan #$id?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.error,
              foregroundColor: Get.theme.colorScheme.onError,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      isLoading.value = true;

      // Delete from server
      await _formProvider.deleteForm(id);

      // Remove from local storage
      reportIds.remove(id);
      await _storage.writeIntList(
        AppConstants.keyReportIds,
        reportIds.toList(),
      );

      Get.snackbar(
        'Success',
        'Laporan #$id berhasil dihapus',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
