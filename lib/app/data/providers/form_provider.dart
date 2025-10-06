import 'package:dio/dio.dart';
import '../models/form_response_model.dart';
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
  Future<bool> submitForm({
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

      return response.statusCode == 200;
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
}
