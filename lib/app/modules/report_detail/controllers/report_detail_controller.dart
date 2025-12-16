import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import '../../../data/providers/form_provider.dart';
import '../../../data/providers/fallback_api_provider.dart';
import '../../../data/models/form_view_response_model.dart';
import '../../../data/models/fallback_image_model.dart';
import '../../../data/models/report_list_item_model.dart';
import '../../../data/services/storage_service.dart';
import '../../../core/values/constants.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../routes/app_routes.dart';

class ReportDetailController extends GetxController {
  final FormProvider _formProvider = FormProvider();
  final StorageService _storage = Get.find<StorageService>();

  // Get report ID and slug from arguments
  late int reportId;
  String? reportSlug;
  ReportListItemModel? listItem; // Item from list with signed image URLs

  // Observable states
  final Rx<FormViewResponseModel?> reportDetail =
      Rx<FormViewResponseModel?>(null);
  final Rx<FallbackImageModel?> fallbackImages = Rx<FallbackImageModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Get report ID and slug from route arguments
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      // New format: {id: int, slug: string, item: ReportListItemModel?}
      reportId = args['id'] as int;
      reportSlug = args['slug'] as String?;
      listItem =
          args['item'] as ReportListItemModel?; // Get item with signed URLs
    } else {
      // Old format: just int (for backward compatibility)
      reportId = args as int;
    }

    loadReportDetail();
  }

  /// Load report detail from API
  Future<void> loadReportDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _formProvider.viewForm(reportId);
      reportDetail.value = response;
      log('response: ${response.toJson()}');
      log('Total answers count: ${response.answers.length}');

      // Load fallback images if this is a pelaporan-penerima-mbg report
      // Use reportSlug from arguments (API doesn't return slug)
      if (reportSlug == 'pelaporan-penerima-mbg') {
        log('Loading fallback images for report $reportId');
        _loadFallbackImages();
      }
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

  /// Load fallback images from fallback API (for pelaporan-penerima-mbg only)
  Future<void> _loadFallbackImages() async {
    try {
      final fallbackProvider = FallbackApiProvider();
      final images = await fallbackProvider.getImagePaths(reportId);

      if (images != null) {
        fallbackImages.value = images;
        log('Fallback images loaded for report $reportId');
      } else {
        log('No fallback images found for report $reportId');
      }
    } catch (e) {
      // Silently fail - fallback is optional
      log('Failed to load fallback images: $e');
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

    // Show loading dialog
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Menghapus laporan...'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // Delete from API server
      await _formProvider.deleteForm(reportId);

      log('Report $reportId deleted from API successfully');

      // Remove from report IDs list
      List<int> reportIds =
          _storage.readIntList(AppConstants.keyReportIds) ?? [];
      reportIds.remove(reportId);
      await _storage.writeIntList(AppConstants.keyReportIds, reportIds);

      // If this is pelaporan-penerima-mbg, also remove from local storage
      if (reportSlug == 'pelaporan-penerima-mbg') {
        await _removeFromLocalStorage();
        log('Report $reportId removed from local storage');
      }

      // Close loading dialog
      Get.back();

      // Show success message
      CustomSnackbar.success(
        title: 'Berhasil',
        message: 'Laporan #$reportId berhasil dihapus',
      );

      // Close detail page and return true to trigger list refresh
      log('Closing detail page, list will refresh');
      Get.back(result: true);
    } catch (e) {
      log('Error deleting report: $e');

      // Close loading dialog
      Get.back();

      CustomSnackbar.error(
        title: 'Error',
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Remove report from local storage (for pelaporan-penerima-mbg only)
  Future<void> _removeFromLocalStorage() async {
    try {
      // Load existing reports from local storage
      final existingData =
          _storage.readObjectList(AppConstants.keyPenerimaMbgReports);

      if (existingData != null) {
        // Parse to ReportListItemModel
        List<ReportListItemModel> reports = existingData
            .map((json) => ReportListItemModel.fromJson(json))
            .toList();

        // Remove report with matching ID
        reports.removeWhere((report) => report.id == reportId);

        // Save back to local storage
        final reportsJson = reports.map((r) => r.toJson()).toList();
        await _storage.writeObjectList(
            AppConstants.keyPenerimaMbgReports, reportsJson);

        log('Report $reportId removed from local storage. Remaining: ${reports.length}');
      }
    } catch (e) {
      log('Error removing report from local storage: $e');
      // Don't throw - local storage removal is not critical
    }
  }

  /// Navigate to edit form
  void editReport() {
    if (reportDetail.value == null || reportSlug == null) {
      CustomSnackbar.error(
        title: 'Error',
        message: 'Data laporan tidak lengkap untuk edit',
      );
      return;
    }

    // Navigate to dynamic form in edit mode
    Get.toNamed(
      Routes.DYNAMIC_FORM,
      arguments: {
        'slug': reportSlug,
        'isEditMode': true,
        'existingData': null, // Not needed - will use responseId
        'responseId': reportId, // Pass responseId for pre-filling
      },
    )?.then((result) {
      // Refresh detail if edit was successful
      if (result == true) {
        loadReportDetail();
      }
    });
  }

  /// Retry loading report detail
  void retryLoad() {
    loadReportDetail();
  }

  /// Convert display text to snake_case format
  /// Example: "Foto Sekolah" -> "foto_sekolah"
  String _toSnakeCase(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), '_') // Replace spaces with underscore
        .replaceAll(RegExp(r'[^\w_]'),
            ''); // Remove special characters except underscore
  }

  /// Get image URL for a question, preferring signed URL from listItem
  ///
  /// If we have listItem (came from list page), use the signed URL from there
  /// Otherwise, use the unsigned URL from viewForm (might not work)
  String? getImageUrl(String questionText) {
    // Convert question text to snake_case for matching with API field names
    final snakeCaseKey = _toSnakeCase(questionText);

    // First try to get from listItem (signed URL)
    if (listItem != null) {
      log('listItem detail keys: ${listItem!.detail.keys.toList()}');
      log('Looking for: $snakeCaseKey (from: $questionText)');

      // Try snake_case key first
      if (listItem!.detail.containsKey(snakeCaseKey)) {
        final url = listItem!.detail[snakeCaseKey];
        if (url != null && url.toString().isNotEmpty) {
          log('Found signed URL with snake_case key: $snakeCaseKey');
          return url.toString();
        }
      }

      // Fallback: try original questionText
      if (listItem!.detail.containsKey(questionText)) {
        final url = listItem!.detail[questionText];
        if (url != null && url.toString().isNotEmpty) {
          log('Found signed URL with original key: $questionText');
          return url.toString();
        }
      }
    }

    // Fallback to viewForm answer (unsigned URL)
    if (reportDetail.value != null) {
      for (var qa in reportDetail.value!.answers) {
        if (qa.question == questionText && qa.answer.isNotEmpty) {
          log('Using unsigned URL from viewForm');
          return qa.answer;
        }
      }
    }

    return null;
  }
}
