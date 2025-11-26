import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/version_check_response_model.dart';

class VersionProvider {
  final Dio _dio;

  VersionProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://hirumi.xyz/fallback_api/api',
            connectTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // Add interceptor for logging
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

  /// Check version from API
  /// Endpoint: GET /version/check
  Future<VersionCheckResponseModel> checkVersion({String? currentVersion}) async {
    try {
      log('Checking version from API...', name: 'VersionProvider');

      // Build query parameters
      final queryParams = <String, dynamic>{};
      if (currentVersion != null) {
        queryParams['current_version'] = currentVersion;
      }

      final response = await _dio.get(
        '/version/check',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      log('Version check response: ${response.data}', name: 'VersionProvider');

      return VersionCheckResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      log('DioException in checkVersion: ${e.message}', name: 'VersionProvider');

      if (e.response != null) {
        // Server responded with error
        log('Response status: ${e.response?.statusCode}', name: 'VersionProvider');
        log('Response data: ${e.response?.data}', name: 'VersionProvider');

        throw Exception(
          e.response?.data['message'] ?? 'Gagal memeriksa versi aplikasi',
        );
      } else {
        // Connection error
        throw Exception('Koneksi ke server gagal. Periksa koneksi internet Anda.');
      }
    } catch (e) {
      log('Unknown error in checkVersion: $e', name: 'VersionProvider');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
