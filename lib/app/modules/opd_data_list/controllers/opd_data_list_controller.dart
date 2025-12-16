import 'package:get/get.dart';
import '../../../data/providers/form_provider.dart';
import '../../../data/models/report_list_item_model.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../routes/app_routes.dart';

class OpdDataListController extends GetxController {
  final FormProvider _formProvider = Get.find<FormProvider>();

  // Arguments from route
  late String slug;
  late String menuTitle;

  // Observable states
  final RxList<ReportListItemModel> dataList = <ReportListItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // Get arguments from route
    final args = Get.arguments as Map<String, dynamic>;
    slug = args['slug'] as String;
    menuTitle = args['menuTitle'] as String;

    // Load data
    loadData();
  }

  /// Load data from API
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _formProvider.getOpdDataList(slug);
      dataList.value = response.data;
      totalCount.value = response.total;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      CustomSnackbar.error(
        title: 'Error',
        message: errorMessage.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data (pull to refresh)
  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      errorMessage.value = '';

      final response = await _formProvider.getOpdDataList(slug);
      dataList.value = response.data;
      totalCount.value = response.total;

      CustomSnackbar.success(
        title: 'Berhasil',
        message: 'Data berhasil diperbarui',
      );
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      CustomSnackbar.error(
        title: 'Error',
        message: errorMessage.value,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Navigate to report detail
  void navigateToDetail(ReportListItemModel item) {
    Get.toNamed(
      Routes.REPORT_DETAIL,
      arguments: {
        'id': item.id,
        'slug': slug,
        'item': item, // Pass full item with signed image URLs
      },
    )?.then((result) {
      // If result is true, it means the report was deleted or updated
      // Refresh the list
      if (result == true) {
        refreshData();
      }
    });
  }

  /// Navigate to create new data
  void navigateToCreate() {
    Get.toNamed(
      Routes.DYNAMIC_FORM,
      arguments: slug,
    )?.then((result) {
      // Refresh list after creating new data
      if (result == true) {
        refreshData();
      }
    });
  }
}
