import 'package:get/get.dart';
import '../../../data/models/sppg_item_model.dart';
import '../../../data/providers/form_provider.dart';

class SppgListController extends GetxController {
  final FormProvider _formProvider = FormProvider();

  // Observable states
  final RxList<SppgItemModel> allSppgList = <SppgItemModel>[].obs;
  final RxList<SppgItemModel> filteredSppgList = <SppgItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Filter and search states
  final RxString selectedKecamatan = 'Semua'.obs;
  final RxString searchQuery = ''.obs;
  final RxList<String> kecamatanList = <String>['Semua'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSppgList();
  }

  /// Fetch SPPG list from API
  Future<void> fetchSppgList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _formProvider.getSppgList();

      if (response.isSuccess) {
        allSppgList.value = response.data;

        // Extract unique kecamatan for filter
        final kecamatanSet = <String>{};
        for (var sppg in response.data) {
          if (sppg.detail.kecamatan.isNotEmpty) {
            kecamatanSet.add(sppg.detail.kecamatan);
          }
        }
        kecamatanList.value = ['Semua', ...kecamatanSet.toList()..sort()];

        // Apply initial filter
        applyFilter();
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh list (pull to refresh)
  Future<void> refreshList() async {
    await fetchSppgList();
  }

  /// Apply filter and search
  void applyFilter() {
    var tempList = allSppgList.toList();

    // Filter by Kecamatan
    if (selectedKecamatan.value != 'Semua') {
      tempList = tempList
          .where((sppg) => sppg.detail.kecamatan == selectedKecamatan.value)
          .toList();
    }

    // Search by nama SPPG
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      tempList = tempList
          .where((sppg) =>
              sppg.detail.namaSppg.toLowerCase().contains(query) ||
              sppg.detail.desa.toLowerCase().contains(query) ||
              sppg.detail.kecamatan.toLowerCase().contains(query))
          .toList();
    }

    filteredSppgList.value = tempList;
  }

  /// Set filter kecamatan
  void setKecamatanFilter(String kecamatan) {
    selectedKecamatan.value = kecamatan;
    applyFilter();
  }

  /// Set search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilter();
  }

  /// Clear filters
  void clearFilters() {
    selectedKecamatan.value = 'Semua';
    searchQuery.value = '';
    applyFilter();
  }

  /// Get total count
  int get totalCount => allSppgList.length;

  /// Get filtered count
  int get filteredCount => filteredSppgList.length;

  /// Check if filters are active
  bool get hasActiveFilters =>
      selectedKecamatan.value != 'Semua' || searchQuery.value.isNotEmpty;
}
