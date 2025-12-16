import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/form_response_model.dart';
import '../models/form_submit_response_model.dart';
import '../models/form_view_response_model.dart';
import '../models/sppg_list_response_model.dart';
import '../models/posyandu_list_response_model.dart';
import '../models/bedas_menanam_list_response_model.dart';
import '../models/menu_opd_list_response_model.dart';
import '../models/report_list_response_model.dart';
import '../../core/values/constants.dart';

class FormProvider {
  final Dio _dio;

  FormProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrlApi,
            connectTimeout:
                const Duration(milliseconds: AppConstants.connectionTimeout),
            receiveTimeout:
                const Duration(milliseconds: AppConstants.receiveTimeout),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // Add interceptor for logging (optional, untuk debugging)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
  }

  /// Get form structure by slug
  /// Example slug: 'lapor-phk'
  Future<FormResponseModel> getFormStructure(String slug) async {
    try {
      final response = await _dio.get(
        '/form/format/$slug',
      );

      return FormResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Server responded with error
        throw Exception(
          'Failed to load form: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        // Network error or timeout
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Submit form data
  /// Endpoint: /form/create/{slug}
  /// Body format: { "uri": "full_url", "answers[id]": "value" }
  /// Returns FormSubmitResponseModel with ID that needs to be saved locally
  Future<FormSubmitResponseModel> submitForm({
    required String slug,
    required Map<String, dynamic> formData,
  }) async {
    log('submitForm: $slug');
    log('formData: $formData');
    try {
      final response = await _dio.post(
        '/form/create/$slug',
        data: FormData.fromMap(formData),
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      // Parse response to get the ID
      if (response.data['status'] == 'success' &&
          response.data['data'] != null) {
        return FormSubmitResponseModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to parse submit response');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to submit form: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// View form detail by ID
  /// Endpoint: GET /api/form/view/{id}
  Future<FormViewResponseModel> viewForm(int id) async {
    try {
      final response = await _dio.get(
        '/form/view/$id',
      );

      if (response.data['status'] == 'success') {
        return FormViewResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load form detail');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle 404 or other errors
        if (e.response?.statusCode == 404) {
          throw Exception('Laporan tidak ditemukan atau sudah dihapus');
        }
        throw Exception(
          'Failed to load form detail: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Delete form by ID
  /// Endpoint: DELETE /api/form/delete/{id}
  Future<bool> deleteForm(int id) async {
    try {
      final response = await _dio.delete(
        '/form/delete/$id',
      );

      return response.data['status'] == 'success';
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          throw Exception('Laporan tidak ditemukan');
        }
        throw Exception(
          'Failed to delete form: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get SPPG list
  /// Endpoint: GET /data/pendataan-profil-sppg-aktif-di-kabupaten-bandung-oleh-kecamatan
  /// Returns list of SPPG with details
  Future<SppgListResponseModel> getSppgList() async {
    final response = await _dio.get(
      '/data/pendataan-profil-sppg-aktif-di-kabupaten-bandung-oleh-kecamatan',
    );

    if (response.data != null) {
      return SppgListResponseModel.fromJson(response.data);
    } else {
      throw Exception('Failed to parse SPPG list response');
    }
  }

  /// Get Posyandu list
  /// Endpoint: GET /data/pendataan-profil-posyandu-aktif-di-kabupaten-bandung
  /// Returns list of Posyandu with details (4567+ items)
  Future<PosyanduListResponseModel> getPosyanduList() async {
    try {
      final response = await _dio.get(
        '/data/pendataan-profil-posyandu-aktif-di-kabupaten-bandung',
      );

      if (response.data != null) {
        // Debug: Log response structure
        log('API Response type: ${response.data.runtimeType}');
        log('API Response keys: ${response.data is Map ? (response.data as Map).keys.toString() : 'Not a Map'}');

        // Check if response.data is a Map or List
        if (response.data is List) {
          // API returns array directly without wrapper
          log('API returns List directly, wrapping in response object');
          final wrappedData = {
            'status': 'success',
            'message': 'Data loaded',
            'pageTitle': '',
            'title': '',
            'slug': 'pendataan-profil-posyandu-aktif-di-kabupaten-bandung',
            'description': '',
            'total': (response.data as List).length,
            'data': response.data,
          };
          return PosyanduListResponseModel.fromJson(wrappedData);
        } else {
          return PosyanduListResponseModel.fromJson(response.data);
        }
      } else {
        throw Exception('Failed to parse Posyandu list response');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to load Posyandu list: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Update existing form data
  /// Endpoint: POST /form/update/{id}
  /// Used for editing Posyandu or other existing form data
  Future<FormSubmitResponseModel> updateForm({
    required int id,
    required String slug,
    required Map<String, dynamic> formData,
  }) async {
    log('updateForm: id=$id, slug=$slug');
    log('formData: $formData');
    try {
      final response = await _dio.post(
        '/form/update/$id',
        data: FormData.fromMap(formData),
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      // Parse response to get updated data
      if (response.data['status'] == 'success') {
        // Return the same FormSubmitResponseModel structure
        return FormSubmitResponseModel.fromJson(response.data['data'] ?? {});
      } else {
        throw Exception('Failed to parse update response');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to update form: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get Bedas Menanam filtered list
  /// Endpoint: GET /api/filter/gerakan-menanam-komoditas-sayuran-untuk-ketahanan-pangan/{kecamatan}/{desa}
  /// Parameters: kecamatan and desa names (uppercase)
  /// Returns filtered list of Bedas Menanam records
  Future<BedasMenanamListResponseModel> getBedasMenanamFiltered({
    required String kecamatan,
    required String desa,
  }) async {
    try {
      // Convert to uppercase for API consistency
      final kecUpper = kecamatan.toUpperCase();
      final desaUpper = desa.toUpperCase();

      final response = await _dio.get(
        '/filter/gerakan-menanam-komoditas-sayuran-untuk-ketahanan-pangan/$kecUpper/$desaUpper',
      );

      if (response.data != null) {
        log('Bedas Menanam API Response type: ${response.data.runtimeType}');

        // API response structure: {"status": "success", "total": 1, "data": [...]}
        return BedasMenanamListResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to parse Bedas Menanam response');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to load Bedas Menanam data: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get OPD Menu list
  /// Endpoint: GET /data/menu-aplikasi-satgas-mbg
  /// Returns list of OPD menus grouped by parent_menu
  Future<MenuOpdListResponseModel> getMenuOpdList() async {
    try {
      final response = await _dio.get(
        '/data/menu-aplikasi-satgas-mbg',
      );

      if (response.data != null) {
        log('Menu OPD API Response type: ${response.data.runtimeType}');

        // API response structure matches standard format
        return MenuOpdListResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to parse Menu OPD response');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to load Menu OPD: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get OPD data list by slug
  /// Endpoint: GET /data/{slug}
  /// Returns list of data items for the given slug
  /// Example: GET /data/pendataan-sekolah-dibawah-kcd-provinsi-dan-kemenag
  Future<ReportListResponseModel> getOpdDataList(String slug) async {
    try {
      final response = await _dio.get(
        '/data/$slug',
      );

      if (response.data != null) {
        log('OPD Data List API Response type: ${response.data.runtimeType}');

        // Check if response.data is a List or Map
        if (response.data is List) {
          // API returns array directly without wrapper
          log('API returns List directly, wrapping in response object');
          final wrappedData = {
            'status': 'success',
            'message': 'Data loaded',
            'pageTitle': '',
            'title': '',
            'slug': slug,
            'description': '',
            'total': (response.data as List).length,
            'data': response.data,
          };
          return ReportListResponseModel.fromJson(wrappedData);
        } else {
          return ReportListResponseModel.fromJson(response.data);
        }
      } else {
        throw Exception('Failed to parse OPD data list response');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to load OPD data: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get form submission statistics by slug
  /// Endpoint: POST /form/index/{slug}
  /// Returns only the total count of submissions
  /// This API is paginated but we only need the "total" field
  Future<int> getFormStatistics(String slug) async {
    try {
      final response = await _dio.post(
        '/form/index/$slug',
        data: {
          'page': 1, // Just get first page to read total
        },
      );

      if (response.data != null && response.data['status'] == 'success') {
        // Extract total from paginated response
        final responsesData = response.data['data']?['responses'];
        if (responsesData != null && responsesData is Map) {
          return responsesData['total'] as int? ?? 0;
        }
        return 0;
      } else {
        throw Exception('Failed to parse form statistics response');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // If 404 or no data, return 0
        if (e.response?.statusCode == 404) {
          return 0;
        }
        throw Exception(
          'Failed to load form statistics: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception(
          'Network error: ${e.message}. Please check your internet connection.',
        );
      }
    } catch (e) {
      log('Error getting form statistics for $slug: $e');
      // Return 0 on error instead of throwing
      return 0;
    }
  }
}
