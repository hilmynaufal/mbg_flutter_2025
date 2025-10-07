import 'package:dio/dio.dart';
import '../models/form_response_model.dart';
import '../models/form_submit_response_model.dart';
import '../models/form_view_response_model.dart';
import '../../core/values/constants.dart';

class FormProvider {
  final Dio _dio;

  FormProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrlApi,
            connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
            receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
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
    try {
      final response = await _dio.post(
        '/form/create/$slug',
        data: FormData.fromMap(formData),
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      // Parse response to get the ID
      if (response.data['status'] == 'success' && response.data['data'] != null) {
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
}
