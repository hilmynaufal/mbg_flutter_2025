import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/form_provider.dart';
import '../../../data/models/form_view_response_model.dart';
import '../../../data/services/storage_service.dart';
import '../../../core/values/constants.dart';

class ReportDetailController extends GetxController {
  final FormProvider _formProvider = FormProvider();
  final StorageService _storage = Get.find<StorageService>();

  // Get report ID from arguments
  late int reportId;

  // Observable states
  final Rx<FormViewResponseModel?> reportDetail = Rx<FormViewResponseModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Get report ID from route arguments
    reportId = Get.arguments as int;

    loadReportDetail();
  }

  /// Load report detail from API
  Future<void> loadReportDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _formProvider.viewForm(reportId);
      reportDetail.value = response;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete report with confirmation
  Future<void> deleteReport() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus Laporan #$reportId?'),
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
      await _formProvider.deleteForm(reportId);

      // Remove from local storage
      List<int> reportIds = _storage.readIntList(AppConstants.keyReportIds) ?? [];
      reportIds.remove(reportId);
      await _storage.writeIntList(AppConstants.keyReportIds, reportIds);

      Get.snackbar(
        'Success',
        'Laporan #$reportId berhasil dihapus',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.TOP,
      );

      // Navigate back to history
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
      );
      isLoading.value = false;
    }
  }

  /// Retry loading report detail
  void retryLoad() {
    loadReportDetail();
  }
}
