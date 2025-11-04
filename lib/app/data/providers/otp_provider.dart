import 'package:dio/dio.dart';
import '../models/otp_send_response_model.dart';
import '../models/otp_verify_response_model.dart';

class OtpProvider {
  final Dio _dio;

  OtpProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://hirumi.xyz/fallback_api/api',
            connectTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    // Add interceptor for logging (optional, for debugging)
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

  /// Send OTP to email
  /// POST /otp/send
  Future<OtpSendResponseModel> sendOtp({required String email}) async {
    try {
      final response = await _dio.post(
        '/otp/send',
        data: {
          'email': email,
        },
      );

      if (response.data['success'] == true) {
        return OtpSendResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to send OTP');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to send OTP',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  /// Verify OTP code
  /// POST /otp/verify
  Future<OtpVerifyResponseModel> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final response = await _dio.post(
        '/otp/verify',
        data: {
          'email': email,
          'otp_code': otpCode,
        },
      );

      if (response.data['success'] == true) {
        return OtpVerifyResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Invalid OTP code');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to verify OTP',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
