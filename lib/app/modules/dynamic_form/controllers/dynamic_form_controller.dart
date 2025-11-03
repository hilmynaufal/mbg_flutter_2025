import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart'
    as dio; // Menggunakan alias 'dio' untuk menghindari konflik nama
import '../../../data/providers/form_provider.dart';
import '../../../data/models/form_response_model.dart';
import '../../../data/services/storage_service.dart';
import '../../../core/values/constants.dart';
import '../../../core/widgets/custom_snackbar.dart';

class DynamicFormController extends GetxController {
  final FormProvider _formProvider = FormProvider();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Observable states
  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  // Form data
  Rx<FormResponseModel?> formStructure = Rx<FormResponseModel?>(null);
  final RxMap<int, dynamic> formValues = <int, dynamic>{}.obs;

  // Form slug - dynamically set from route arguments
  late final String formSlug;

  @override
  void onInit() {
    super.onInit();
    // Get slug from route arguments
    formSlug = Get.arguments as String? ?? 'pelaporan-tugas-satgas-mbg';
    _loadFormStructure();
  }

  // Load form structure from API
  Future<void> _loadFormStructure() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _formProvider.getFormStructure(formSlug);
      formStructure.value = response;
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

  // Submit form
  Future<void> submitForm() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      CustomSnackbar.warning(
        title: 'Validasi Gagal',
        message: 'Mohon lengkapi semua field yang wajib diisi',
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Submit'),
        content: const Text('Apakah Anda yakin ingin mengirim laporan ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      isSubmitting.value = true;

      // Prepare submit data with correct format
      final Map<String, dynamic> submitData = {};

      // Add URI field
      final fullUri = '${AppConstants.baseUrlApi}/form/create/$formSlug';
      submitData['uri'] = fullUri;

      log(formValues.toString());

      // Convert form values to answers[id] format
      for (var entry in formValues.entries) {
        final fieldId = entry.key;
        final value = entry.value;
        final fieldKey = 'answers[$fieldId]';

        if (value == null) {
          continue; // Skip null values
        }

        if (value is DateTime) {
          // Format date as ISO string
          submitData[fieldKey] =
              value.toIso8601String().split('T')[0]; // yyyy-MM-dd
        } else if (value is Map<String, double>) {
          // Map coordinates to string format
          submitData[fieldKey] = '${value['latitude']},${value['longitude']}';
        } else if (value is File) {
          // Handle image upload
          submitData[fieldKey] = await dio.MultipartFile.fromFile(
            // Menggunakan dio.MultipartFile
            value.path,
            filename: value.path.split('/').last,
          );
        } else {
          // Convert other values to string
          submitData[fieldKey] = value.toString();
        }
      }

      // Submit to API
      log('Submitting form data: ${submitData.toString()}');
      final response = await _formProvider.submitForm(
        slug: formSlug,
        formData: submitData,
      );

      // Save report ID to local storage
      final storage = Get.find<StorageService>();
      List<int> reportIds = storage.readIntList(AppConstants.keyReportIds) ?? [];
      reportIds.add(response.id);
      await storage.writeIntList(AppConstants.keyReportIds, reportIds);

      log('Report saved with ID: ${response.id}');

      // Navigate to success screen
      Get.offNamed(
        '/form-success',
        arguments: response,
      );
    } catch (e) {
      CustomSnackbar.error(
        title: 'Error',
        message: e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Retry loading form
  void retryLoadForm() {
    _loadFormStructure();
  }
}
