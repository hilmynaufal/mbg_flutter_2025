import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../data/providers/form_provider.dart';
import '../../../routes/app_routes.dart';

class DynamicFilterController extends GetxController {
  final FormProvider _formProvider = Get.find<FormProvider>();

  // Arguments from route
  late final String slug;
  late final String menuTitle;
  late final String requiredFilter;

  // Text controller for filter field
  late final TextEditingController filterController;

  // Observable states
  final RxList allDataList = [].obs;
  final RxList filteredDataList = [].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasSearched = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Extract arguments
    final args = Get.arguments as Map<String, dynamic>;
    slug = args['slug'] as String;
    menuTitle = args['menuTitle'] as String;
    requiredFilter = args['requiredFilter'] as String;

    // Initialize controller
    filterController = TextEditingController();

    // Load data immediately
    fetchDataList();
  }

  @override
  void onClose() {
    filterController.dispose();
    super.onClose();
  }

  /// Fetch all data from API (background load)
  Future<void> fetchDataList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _formProvider.getOpdDataList(slug);
      allDataList.value = response.data;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      CustomSnackbar.error(
        title: 'Gagal Memuat Data',
        message: errorMessage.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get user-friendly label from field name
  String getFilterLabel() {
    if (requiredFilter.contains('hp') || requiredFilter.contains('whatsapp')) {
      return 'Nomor HP (Whatsapp)';
    }
    if (requiredFilter.contains('email')) {
      return 'Email';
    }
    // Convert snake_case to Title Case
    return requiredFilter
        .split('_')
        .map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Get hint text for field '
  String getFilterHint() {
    if (requiredFilter.contains('hp') || requiredFilter.contains('whatsapp')) {
      return 'Contoh: 081234567890';
    }
    if (requiredFilter.contains('email')) {
      return 'Contoh: email@example.com';
    }
    return 'Masukkan ${getFilterLabel().toLowerCase()}';
  }

  /// Get keyboard type based on field name
  TextInputType getInputType() {
    if (requiredFilter.contains('hp') || requiredFilter.contains('phone')) {
      return TextInputType.phone;
    }
    if (requiredFilter.contains('email')) {
      return TextInputType.emailAddress;
    }
    return TextInputType.text;
  }

  /// Get icon for field
  IconData getFieldIcon() {
    if (requiredFilter.contains('hp') || requiredFilter.contains('whatsapp')) {
      return Icons.phone;
    }
    if (requiredFilter.contains('email')) {
      return Icons.email;
    }
    return Icons.text_fields;
  }

  /// Search data by filter value
  Future<void> searchByFilter() async {
    final filterValue = filterController.text.trim();

    // Validate filter value
    if (filterValue.isEmpty) {
      CustomSnackbar.error(
        title: 'Field Wajib Diisi',
        message: 'Harap isi ${getFilterLabel().toLowerCase()} terlebih dahulu',
      );
      return;
    }

    // Wait if data still loading
    if (isLoading.value) {
      CustomSnackbar.info(
        title: 'Mohon Tunggu',
        message: 'Data masih dimuat, silakan tunggu sebentar',
      );
      return;
    }

    try {
      isSearching.value = true;

      // Filter data client-side
      final results = allDataList.where((item) {
        final fieldValue = item.detail[requiredFilter]?.toString() ?? '';

        // Handle phone number (remove leading 0)
        if (requiredFilter.contains('hp') ||
            requiredFilter.contains('phone') ||
            requiredFilter.contains('whatsapp')) {
          final searchPhone = filterValue.startsWith('0')
              ? filterValue.substring(1)
              : filterValue;
          final itemPhone =
              fieldValue.startsWith('0') ? fieldValue.substring(1) : fieldValue;
          return itemPhone == searchPhone;
        }

        // For other fields, exact match
        return fieldValue.toLowerCase() == filterValue.toLowerCase();
      }).toList();

      // Update filtered list
      filteredDataList.value = results;
      hasSearched.value = true;

      // Show message if no results
      if (results.isEmpty) {
        CustomSnackbar.error(
          title: 'Data Tidak Ditemukan',
          message:
              'Tidak ada data dengan ${getFilterLabel().toLowerCase()} "$filterValue"',
        );
      }
    } finally {
      isSearching.value = false;
    }
  }

  /// Clear filter
  void clearFilter() {
    filterController.clear();
    filteredDataList.clear();
    hasSearched.value = false;
  }

  /// Navigate to detail page
  void navigateToDetail(dynamic item) {
    Get.toNamed(
      Routes.REPORT_DETAIL,
      arguments: {
        'id': item.id,
        'slug': slug,
        'item': item, // Pass full item with signed image URLs
      },
    );
  }
}
