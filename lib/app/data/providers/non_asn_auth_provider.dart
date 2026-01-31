import 'package:dio/dio.dart';

import '../../core/values/constants.dart';

class NonAsnAuthProvider {
  final Dio _dio;

  NonAsnAuthProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://dhephl.bandungkab.go.id/api',
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

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      // Return the raw data map, transformation will be done in AuthService/UserModel
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Login failed: ${e.response?.data['message'] ?? e.message}',
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
