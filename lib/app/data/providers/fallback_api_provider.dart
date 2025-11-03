import 'dart:io';
import 'package:dio/dio.dart';
import '../models/fallback_image_model.dart';

class FallbackApiProvider {
  final Dio _dio;

  FallbackApiProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://hirumi.xyz/fallback_api/api',
            connectTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
            headers: {
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

  /// Upload images to fallback API
  /// Used after successful form submission to main API
  Future<FallbackImageModel> uploadImages({
    required int id,
    required int idUser,
    File? dokumentasiFoto1,
    File? dokumentasiFoto2,
    File? dokumentasiFoto3,
  }) async {
    try {
      // Prepare form data
      final formData = FormData();

      formData.fields.add(MapEntry('id', id.toString()));
      formData.fields.add(MapEntry('id_user', idUser.toString()));

      // Add image files if provided
      if (dokumentasiFoto1 != null) {
        formData.files.add(
          MapEntry(
            'dokumentasi_foto_1',
            await MultipartFile.fromFile(
              dokumentasiFoto1.path,
              filename: dokumentasiFoto1.path.split('/').last,
            ),
          ),
        );
      }

      if (dokumentasiFoto2 != null) {
        formData.files.add(
          MapEntry(
            'dokumentasi_foto_2',
            await MultipartFile.fromFile(
              dokumentasiFoto2.path,
              filename: dokumentasiFoto2.path.split('/').last,
            ),
          ),
        );
      }

      if (dokumentasiFoto3 != null) {
        formData.files.add(
          MapEntry(
            'dokumentasi_foto_3',
            await MultipartFile.fromFile(
              dokumentasiFoto3.path,
              filename: dokumentasiFoto3.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.post(
        '/image-paths',
        data: formData,
      );

      return FallbackImageModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Failed to upload images to fallback API: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  /// Get image paths from fallback API by form ID
  /// Returns fallback image URLs
  Future<FallbackImageModel?> getImagePaths(int id) async {
    try {
      final response = await _dio.get('/image-paths/$id');

      if (response.data['success'] == true && response.data['data'] != null) {
        return FallbackImageModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException catch (e) {
      // Return null if not found or error (don't throw, this is fallback)
      if (e.response?.statusCode == 404) {
        return null;
      }

      // Log error but don't throw - fallback API should not break main flow
      print('Fallback API error: ${e.message}');
      return null;
    }
  }
}
