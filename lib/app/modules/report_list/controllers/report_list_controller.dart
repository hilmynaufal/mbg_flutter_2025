import 'package:get/get.dart';
import '../../../data/providers/content_provider.dart';
import '../../../data/models/report_list_item_model.dart';
import '../../../data/models/report_list_response_model.dart';
import '../../../data/services/storage_service.dart';
import '../../../core/values/constants.dart';
import '../../../core/widgets/custom_snackbar.dart';

class ReportListController extends GetxController {
  final ContentProvider _contentProvider = Get.find<ContentProvider>();

  // Observable properties
  RxList<ReportListItemModel> reports = <ReportListItemModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString pageTitle = ''.obs;
  RxString description = ''.obs;
  RxInt total = 0.obs;

  // Report type (sppg, ikl, or penerima-mbg)
  late String reportType;

  // Get slug from report type
  String get slug {
    switch (reportType) {
      case 'sppg':
        return 'pelaporan-tugas-satgas-mbg';
      case 'ikl':
        return 'pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl';
      case 'penerima-mbg':
        return 'pelaporan-penerima-mbg';
      default:
        return 'pelaporan-tugas-satgas-mbg';
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Get report type from route arguments
    reportType = Get.arguments as String? ?? 'sppg';
    loadReports();
  }

  /// Load reports based on type
  Future<void> loadReports() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // For penerima-mbg, load from local storage instead of API
      if (reportType == 'penerima-mbg') {
        final storage = Get.find<StorageService>();
        final existingData = storage.readObjectList(AppConstants.keyPenerimaMbgReports);

        if (existingData != null) {
          reports.value = existingData
              .map((json) => ReportListItemModel.fromJson(json))
              .toList();
        } else {
          reports.value = [];
        }

        // Set metadata for penerima-mbg
        pageTitle.value = 'Laporan Harian Saya';
        description.value = 'Daftar laporan penerima MBG yang tersimpan di perangkat Anda';
        total.value = reports.length;
      } else {
        // For other types, load from API
        ReportListResponseModel response;

        if (reportType == 'sppg') {
          response = await _contentProvider.getReportsSppg();
        } else if (reportType == 'ikl') {
          response = await _contentProvider.getReportsIkl();
        } else {
          // Default to SPPG if unknown type
          response = await _contentProvider.getReportsSppg();
        }

        reports.value = response.data;
        pageTitle.value = response.title;
        description.value = response.description;
        total.value = response.total;
      }
    } catch (e) {
      print('Error loading reports: $e');
      errorMessage.value = e.toString();
      CustomSnackbar.error(
        title: 'Gagal Memuat Data',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh reports (pull to refresh)
  Future<void> refreshReports() async {
    await loadReports();
  }

  /// Retry loading reports
  Future<void> retry() async {
    await loadReports();
  }
}
