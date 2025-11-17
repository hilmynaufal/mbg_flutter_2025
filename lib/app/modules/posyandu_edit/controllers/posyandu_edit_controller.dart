import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/posyandu_item_model.dart';
import '../../../data/providers/form_provider.dart';
import '../../../routes/app_routes.dart';

class PosyanduEditController extends GetxController {
  final FormProvider _formProvider = FormProvider();

  // Route arguments
  late String formSlug; // 'pendataan-profil-posyandu-aktif-di-kabupaten-bandung' or 'pelaporan-tugas-satgas-mbg'
  late String menuTitle; // For AppBar title

  // Observable states
  final RxList<PosyanduItemModel> allPosyanduList = <PosyanduItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxString errorMessage = ''.obs;

  // Text controller for phone input
  final phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Get arguments from route
    final args = Get.arguments as Map<String, dynamic>?;
    formSlug = args?['slug'] ?? '';
    menuTitle = args?['title'] ?? 'Edit Posyandu';

    // Fetch data immediately on menu open (in background)
    fetchPosyanduList();
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  /// Fetch all Posyandu data from API (background load)
  Future<void> fetchPosyanduList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _formProvider.getPosyanduList();

      if (response.isSuccess) {
        allPosyanduList.value = response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Gagal Memuat Data',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Search Posyandu by phone and navigate to detail
  Future<void> searchByPhone() async {
    final phone = phoneController.text.trim();

    // Validate phone number
    if (phone.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon masukkan nomor HP',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // // Validate phone format (must be digits, 10-13 chars)
    // if (!RegExp(r'^\d{10,13}$').hasMatch(phone)) {
    //   Get.snackbar(
    //     'Validasi Gagal',
    //     'Nomor HP harus 10-13 digit angka',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return;
    // }

    // Wait if data still loading
    if (isLoading.value) {
      Get.snackbar(
        'Mohon Tunggu',
        'Data masih dimuat, silakan tunggu sebentar',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSearching.value = true;

      // Remove leading 0 for comparison
      final searchPhone = phone.startsWith('0') ? phone.substring(1) : phone;

      // Find exact match by phone number
      final result = allPosyanduList.firstWhereOrNull((posyandu) {
        final posyanduPhone = posyandu.detail.noHpPelapor.toString();
        return posyanduPhone == searchPhone;
      });

      if (result != null) {
        // Navigate to detail page
        Get.toNamed(
          Routes.POSYANDU_DETAIL,
          arguments: {
            'posyandu': result,
            'formSlug': formSlug,
          },
        );
      } else {
        Get.snackbar(
          'Data Tidak Ditemukan',
          'Tidak ada posyandu dengan nomor HP $phone',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isSearching.value = false;
    }
  }

  /// Clear search input
  void clearSearch() {
    phoneController.clear();
  }

}
