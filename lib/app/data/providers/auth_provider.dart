import 'package:dio/dio.dart';
import '../models/login_response_model.dart';
import '../../core/values/constants.dart';

class AuthProvider {
  final Dio _dio;

  AuthProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrlSultan,
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

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/Login',
        data: {
          'username': username,
          'password': password,
        },
      );

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Server responded with error
        throw Exception(
          'Login failed: ${e.response?.data['message'] ?? e.message}',
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
}
