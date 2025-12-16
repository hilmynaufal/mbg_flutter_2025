import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart'
    as dio; // Menggunakan alias 'dio' untuk menghindari konflik nama
import '../../../data/providers/form_provider.dart';
import '../../../data/providers/fallback_api_provider.dart';
import '../../../data/models/form_response_model.dart';
import '../../../data/models/form_field_model.dart';
import '../../../data/models/report_list_item_model.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/auth_service.dart';
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

  // Edit mode parameters
  bool isEditMode = false;
  dynamic existingData; // Can be PosyanduItemModel or other types
  int? responseId;

  @override
  void onInit() {
    super.onInit();

    // Get arguments from route
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      // New format with edit mode support
      formSlug = args['slug'] as String? ?? 'pelaporan-tugas-satgas-mbg';
      isEditMode = args['isEditMode'] as bool? ?? false;
      existingData = args['existingData'];

      // Extract responseId - try from arguments first, then from existingData
      responseId = args['responseId'] as int?;

      if (responseId == null && isEditMode && existingData != null) {
        try {
          responseId = (existingData as dynamic).id as int?;
        } catch (e) {
          log('Failed to extract responseId from existingData: $e');
        }
      }
    } else {
      // Old format - just slug string
      formSlug = args as String? ?? 'pelaporan-tugas-satgas-mbg';
    }

    _loadFormStructure();
  }

  // Load form structure from API
  Future<void> _loadFormStructure() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _formProvider.getFormStructure(formSlug);
      formStructure.value = response;

      // Pre-fill form if in edit mode with responseId
      if (isEditMode && responseId != null) {
        await _preFillFormValues();
      }
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

  // Pre-fill form values from existing data using viewForm API
  Future<void> _preFillFormValues() async {
    if (formStructure.value == null || responseId == null) return;

    try {
      log('Edit mode: Pre-filling form with responseId: $responseId');

      // Fetch existing form data from API
      final viewResponse = await _formProvider.viewForm(responseId!);

      log('Form data loaded. Answers count: ${viewResponse.answers.length}');

      // Create a map for quick lookup: question -> answer
      final answersMap = <String, String>{};
      for (var qa in viewResponse.answers) {
        answersMap[qa.question] = qa.answer;
      }

      log('Answers map: ${answersMap.keys.toList()}');

      // Match form fields with answers
      int matchedCount = 0;
      for (var field in formStructure.value!.data) {
        try {
          // Try exact match first
          String? matchedAnswer;

          if (answersMap.containsKey(field.questionText)) {
            // Exact match
            matchedAnswer = answersMap[field.questionText];
          } else {
            // Try normalized match
            final questionTextNormalized = _normalizeText(field.questionText);

            for (var entry in answersMap.entries) {
              final answerQuestionNormalized = _normalizeText(entry.key);

              if (questionTextNormalized == answerQuestionNormalized) {
                matchedAnswer = entry.value;
                break;
              }
            }
          }

          // If match found, pre-fill the form field
          if (matchedAnswer != null && matchedAnswer.isNotEmpty) {
            _preFillField(field, matchedAnswer);
            matchedCount++;
            log('✓ Matched: "${field.questionText}" = "$matchedAnswer"');
          } else {
            log('✗ No match for: "${field.questionText}"');
          }
        } catch (e) {
          log('Error pre-filling field ${field.questionText}: $e');
          continue;
        }
      }

      log('Pre-fill completed: $matchedCount/${formStructure.value!.data.length} fields filled');

      // Trigger UI update to sync TextEditingControllers
      update();
    } catch (e) {
      log('Error pre-filling form data: $e');
      // Non-critical error, just log it
    }
  }

  // Normalize text for matching (lowercase, remove spaces/underscores)
  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('_', '')
        .replaceAll('-', '');
  }

  // Pre-fill individual field based on type
  // Note: API returns all answers as strings, so we need to parse them
  void _preFillField(FormFieldModel field, String value) {
    try {
      if (value.isEmpty) {
        log('Skipping empty value for: ${field.questionText}');
        return;
      }

      switch (field.questionType) {
        case 'text':
        case 'textarea':
          formValues[field.id] = value;
          log('  → Set as text: "$value"');
          break;

        case 'number':
          final numValue = int.tryParse(value);
          if (numValue != null) {
            formValues[field.id] = numValue;
            log('  → Set as number: $numValue');
          } else {
            log('  → Failed to parse number: "$value"');
          }
          break;

        case 'dropdown':
        case 'radio':
          formValues[field.id] = value;
          log('  → Set as dropdown/radio: "$value"');
          break;

        case 'date':
          try {
            // Try to parse date string (format: yyyy-MM-dd or yyyy-MM-dd HH:mm:ss)
            final datePart = value.split(' ')[0]; // Get only date part
            final dateValue = DateTime.parse(datePart);
            formValues[field.id] = dateValue;
            log('  → Set as date: $dateValue');
          } catch (e) {
            log('  → Failed to parse date: "$value" - $e');
          }
          break;

        case 'map':
          if (value.contains(',')) {
            // Parse "lat,lng" format
            final parts = value.split(',').map((e) => e.trim()).toList();
            if (parts.length == 2) {
              final lat = double.tryParse(parts[0]);
              final lng = double.tryParse(parts[1]);
              if (lat != null && lng != null) {
                formValues[field.id] = {
                  'latitude': lat,
                  'longitude': lng,
                };
                log('  → Set as map coordinates: lat=$lat, lng=$lng');
              } else {
                log('  → Failed to parse coordinates: "$value"');
              }
            }
          } else {
            log('  → Invalid coordinate format: "$value"');
          }
          break;

        case 'image':
          // Image fields cannot be pre-filled from URL/path
          // User will need to re-upload
          log('  → Skipping image field (need manual re-upload)');
          break;

        default:
          log('  → Unknown field type: ${field.questionType}');
      }
    } catch (e) {
      log('Error setting value for field ${field.id}: $e');
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

        //TODO: UBAH DYNAMIC FORM (sementara hardcode)
        if (value == null) {
          continue; // Skip null values
        }

        if (fieldId == 1070) {
          //skip kecamatan
          continue;
        }

        if (fieldId == 1059) {
          //skip desa
          continue;
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

      // Submit to API (create or update based on mode)
      log('${isEditMode ? "Updating" : "Submitting"} form data: ${submitData.toString()}');

      final response = isEditMode && responseId != null
          ? await _formProvider.updateForm(
              id: responseId!,
              slug: formSlug,
              formData: submitData,
            )
          : await _formProvider.submitForm(
              slug: formSlug,
              formData: submitData,
            );

      // Save report ID to local storage (only for new submissions)
      if (!isEditMode) {
        final storage = Get.find<StorageService>();
        List<int> reportIds =
            storage.readIntList(AppConstants.keyReportIds) ?? [];
        reportIds.add(response.id);
        await storage.writeIntList(AppConstants.keyReportIds, reportIds);
      }

      log('Report saved with ID: ${response.id}');

      // Save full report to local storage if this is pelaporan-penerima-mbg form (only for new submissions)
      if (!isEditMode && formSlug == 'pelaporan-penerima-mbg') {
        await _saveReportToLocalStorage(response);
      }

      // Upload images to fallback API if this is pelaporan-penerima-mbg form
      if (formSlug == 'pelaporan-penerima-mbg') {
        _uploadToFallbackApi(response.id).catchError((error) {
          // Log error but don't block user flow
          log('Fallback API upload failed: $error');
        });
      }

      // Handle navigation - both create and update go to success screen
      Get.offNamed(
        '/form-success',
        arguments: {
          'response': response,
          'slug': formSlug,
          'isEditMode': isEditMode,
        },
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

  // Upload images to fallback API for pelaporan-penerima-mbg
  Future<void> _uploadToFallbackApi(int formId) async {
    try {
      // Get user ID from AuthService
      final authService = Get.find<AuthService>();
      final currentUser = authService.currentUser;

      if (currentUser == null) {
        log('User not found, skipping fallback upload');
        return;
      }

      // Determine user ID based on user type
      // For Non-PNS: use NIK as user ID
      // For PNS: use id field
      int userId;
      if (currentUser.isNonPns && currentUser.nik != null) {
        // Convert NIK string to int for fallback API
        try {
          userId = int.parse(currentUser.nik!);
        } catch (e) {
          log('Failed to parse NIK as int: ${currentUser.nik}, error: $e');
          log('Skipping fallback upload due to invalid NIK');
          return;
        }
      } else {
        userId = currentUser.id;
      }

      // Extract image files that match dokumentasi_foto pattern
      final Map<String, File?> imageFiles = {
        'dokumentasi_foto_1': null,
        'dokumentasi_foto_2': null,
        'dokumentasi_foto_3': null,
      };

      // Match field IDs with field names containing 'dokumentasi_foto'
      if (formStructure.value != null) {
        for (var field in formStructure.value!.data) {
          if (field.questionType == 'image') {
            final questionTextLower = field.questionText.toLowerCase();

            // Check if field name contains dokumentasi_foto
            if (questionTextLower.contains('dokumentasi_foto') ||
                questionTextLower.contains('dokumentasi foto')) {
              // Get the file from formValues
              final fileValue = formValues[field.id];

              if (fileValue is File) {
                // Determine which dokumentasi_foto this is based on question text
                if (questionTextLower.contains('1') ||
                    (imageFiles['dokumentasi_foto_1'] == null &&
                        !questionTextLower.contains('2') &&
                        !questionTextLower.contains('3'))) {
                  imageFiles['dokumentasi_foto_1'] = fileValue;
                } else if (questionTextLower.contains('2')) {
                  imageFiles['dokumentasi_foto_2'] = fileValue;
                } else if (questionTextLower.contains('3')) {
                  imageFiles['dokumentasi_foto_3'] = fileValue;
                }
              }
            }
          }
        }
      }

      // Only upload if at least one image exists
      if (imageFiles.values.any((file) => file != null)) {
        final fallbackProvider = FallbackApiProvider();
        await fallbackProvider.uploadImages(
          id: formId,
          idUser: userId,
          dokumentasiFoto1: imageFiles['dokumentasi_foto_1'],
          dokumentasiFoto2: imageFiles['dokumentasi_foto_2'],
          dokumentasiFoto3: imageFiles['dokumentasi_foto_3'],
        );
        log('Fallback API upload successful for form ID: $formId');
      } else {
        log('No dokumentasi_foto images found, skipping fallback upload');
      }
    } catch (e) {
      log('Error uploading to fallback API: $e');
      // Don't rethrow - we don't want to block the main flow
    }
  }

  // Save report to local storage for pelaporan-penerima-mbg
  Future<void> _saveReportToLocalStorage(dynamic response) async {
    try {
      final storage = Get.find<StorageService>();
      final authService = Get.find<AuthService>();
      final currentUser = authService.currentUser;

      // Construct detail map from formValues
      final Map<String, dynamic> detail = {};

      if (formStructure.value != null) {
        for (var field in formStructure.value!.data) {
          final value = formValues[field.id];

          if (value != null) {
            // Convert value to storable format
            if (value is DateTime) {
              detail[field.questionText] =
                  value.toIso8601String().split('T')[0];
            } else if (value is Map<String, double>) {
              detail[field.questionText] =
                  '${value['latitude']},${value['longitude']}';
            } else if (value is File) {
              // Store file path for local reference (won't work after file deletion)
              detail[field.questionText] = value.path;
            } else {
              detail[field.questionText] = value.toString();
            }
          }
        }
      }

      // Create ReportListItemModel
      final report = ReportListItemModel(
        id: response.id,
        departmentId: response.skpdId ?? 0,
        departmentNama: response.skpdNama ?? '',
        asistantNama: '', // Not available in response
        createdBy: currentUser?.nmLengkap ?? currentUser?.username ?? '',
        createdAt: DateTime.parse(response.createdAt),
        updatedBy: currentUser?.nmLengkap ?? currentUser?.username ?? '',
        updatedAt: DateTime.parse(response.updatedAt),
        detail: detail,
      );

      // Load existing reports from local storage
      List<ReportListItemModel> reports = [];
      final existingData =
          storage.readObjectList(AppConstants.keyPenerimaMbgReports);

      if (existingData != null) {
        reports = existingData
            .map((json) => ReportListItemModel.fromJson(json))
            .toList();
      }

      // Add new report at the beginning (most recent first)
      reports.insert(0, report);

      // Save back to local storage
      final reportsJson = reports.map((r) => r.toJson()).toList();
      await storage.writeObjectList(
          AppConstants.keyPenerimaMbgReports, reportsJson);

      log('Report saved to local storage: ${report.id}');
    } catch (e) {
      log('Error saving report to local storage: $e');
      // Don't throw - this shouldn't block the submission flow
    }
  }
}
