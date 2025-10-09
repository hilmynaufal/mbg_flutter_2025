import 'package:get/get.dart';
import '../../../data/providers/content_provider.dart';
import '../../../data/models/report_list_item_model.dart';
import '../../../data/models/report_list_response_model.dart';
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

  // Report type (sppg or ikl)
  late String reportType;

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

      ReportListResponseModel response;

      if (reportType == 'sppg') {
        response = await _contentProvider.getReportsSppg();
      } else {
        response = await _contentProvider.getReportsIkl();
      }

      reports.value = response.data;
      pageTitle.value = response.title;
      description.value = response.description;
      total.value = response.total;
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
