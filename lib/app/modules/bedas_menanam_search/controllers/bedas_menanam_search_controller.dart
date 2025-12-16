import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/bedas_menanam_item_model.dart';
import '../../../data/models/kecamatan_model.dart';
import '../../../data/models/desa_model.dart';
import '../../../data/regional_data.dart';
import '../../../data/providers/form_provider.dart';
import '../../../routes/app_routes.dart';

class BedasMenanamSearchController extends GetxController {
  final FormProvider _formProvider = FormProvider();

  // Route arguments
  late String formSlug;
  late String menuTitle;

  // Observable states
  final RxList<BedasMenanamItemModel> filteredList = <BedasMenanamItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxString errorMessage = ''.obs;

  // Selected filters
  final Rx<KecamatanModel?> selectedKecamatan = Rx<KecamatanModel?>(null);
  final Rx<DesaModel?> selectedDesa = Rx<DesaModel?>(null);
  final phoneController = TextEditingController();

  // Available desa list (depends on selected kecamatan)
  final RxList<DesaModel> availableDesaList = <DesaModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Get arguments
    final args = Get.arguments as Map<String, dynamic>?;
    formSlug = args?['slug'] ?? '';
    menuTitle = args?['title'] ?? 'Cari Data Bedas Menanam';
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  /// Handle kecamatan selection
  void onKecamatanChanged(KecamatanModel? kecamatan) {
    selectedKecamatan.value = kecamatan;
    selectedDesa.value = null; // Reset desa when kecamatan changes

    if (kecamatan != null) {
      // Load desa options for selected kecamatan
      availableDesaList.value = RegionalData.getDesaByKecamatan(kecamatan.idKec);
    } else {
      availableDesaList.clear();
    }
  }

  /// Handle desa selection
  void onDesaChanged(DesaModel? desa) {
    selectedDesa.value = desa;
  }

  /// Fetch filtered data from API
  Future<void> searchByRegion() async {
    // Validate kecamatan and desa selection
    if (selectedKecamatan.value == null) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon pilih Kecamatan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedDesa.value == null) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon pilih Desa terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSearching.value = true;
      errorMessage.value = '';

      final response = await _formProvider.getBedasMenanamFiltered(
        kecamatan: selectedKecamatan.value!.nmKec,
        desa: selectedDesa.value!.nmDesa,
      );

      if (response.isSuccess) {
        filteredList.value = response.data;

        if (filteredList.isEmpty) {
          Get.snackbar(
            'Data Tidak Ditemukan',
            'Tidak ada data untuk Kecamatan ${selectedKecamatan.value!.nmKec} - Desa ${selectedDesa.value!.nmDesa}',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        throw Exception(response.status);
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Gagal Memuat Data',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      filteredList.clear();
    } finally {
      isSearching.value = false;
    }
  }

  /// Search by phone number - fetches data by region first, then filters by phone
  Future<void> searchByPhone() async {
    final phone = phoneController.text.trim();

    // Validate phone number input
    if (phone.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon masukkan nomor WhatsApp',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validate kecamatan and desa selection
    if (selectedKecamatan.value == null) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon pilih Kecamatan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedDesa.value == null) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon pilih Desa terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSearching.value = true;
      errorMessage.value = '';

      // Step 1: Fetch data by region (kecamatan & desa)
      final response = await _formProvider.getBedasMenanamFiltered(
        kecamatan: selectedKecamatan.value!.nmKec,
        desa: selectedDesa.value!.nmDesa,
      );

      if (!response.isSuccess) {
        throw Exception(response.status);
      }

      // Step 2: Filter by phone number from fetched data
      // Remove leading 0 for comparison
      final searchPhone = phone.startsWith('0') ? phone.substring(1) : phone;

      // Find all matches by phone number
      final results = response.data.where((item) {
        final itemPhone = item.detail.nomorWhatsappPelapor.toString();
        return itemPhone == searchPhone;
      }).toList();

      // Handle search results
      if (results.isEmpty) {
        // Clear filtered list when no results found
        filteredList.clear();
        Get.snackbar(
          'Data Tidak Ditemukan',
          'Tidak ada data dengan nomor WhatsApp $phone untuk Kecamatan ${selectedKecamatan.value!.nmKec} - Desa ${selectedDesa.value!.nmDesa}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else if (results.length == 1) {
        // Single result, navigate directly
        filteredList.clear(); // Clear list before navigation
        navigateToDetail(results.first);
      } else {
        // Multiple results, show selection dialog and update filtered list
        filteredList.value = results;
        _showMultipleResultsDialog(results);
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Gagal Memuat Data',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      filteredList.clear();
    } finally {
      isSearching.value = false;
    }
  }

  /// Show dialog for multiple results
  void _showMultipleResultsDialog(List<BedasMenanamItemModel> results) {
    Get.dialog(
      AlertDialog(
        title: const Text('Beberapa Data Ditemukan'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return ListTile(
                leading: const Icon(Icons.agriculture),
                title: Text(item.detail.namaLengkapPelapor),
                subtitle: Text('ID: ${item.id} - ${item.detail.jenisPangan}'),
                onTap: () {
                  Get.back();
                  navigateToDetail(item);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  /// Navigate to detail page
  void navigateToDetail(BedasMenanamItemModel item) {
    Get.toNamed(
      Routes.BEDAS_MENANAM_DETAIL,
      arguments: {
        'item': item,
        'formSlug': formSlug,
      },
    );
  }

  /// Clear all filters
  void clearFilters() {
    selectedKecamatan.value = null;
    selectedDesa.value = null;
    phoneController.clear();
    availableDesaList.clear();
    filteredList.clear();
  }
}
