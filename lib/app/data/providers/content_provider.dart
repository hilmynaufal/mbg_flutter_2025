import 'package:dio/dio.dart';
import '../models/slide_model.dart';
import '../models/news_model.dart';
import '../models/report_list_response_model.dart';
import 'dart:developer';

class ContentProvider {
  final Dio _dio;

  ContentProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.bandungkab.go.id/api',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // Add logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('[ContentProvider] $obj'),
      ),
    );
  }

  /// Get slides/carousel data
  /// GET /site/12/slides
  Future<List<SlideModel>> getSlides() async {
    try {
      final response = await _dio.get('/site/12/slides');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> slidesJson = data['data'] as List<dynamic>;
          return slidesJson
              .map((json) => SlideModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
              'Invalid response format: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load slides: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load slides: $e');
    }
  }

  /// Get posts/news list
  /// GET /site/12/posts
  Future<List<NewsModel>> getPosts({int? limit}) async {
    try {
      final response = await _dio.get(
        '/site/12/posts',
        queryParameters: limit != null ? {'limit': limit} : null,
      );

      log('response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> postsJson = data['data'] as List<dynamic>;
          var posts = postsJson
              .map((json) => NewsModel.fromJson(json as Map<String, dynamic>))
              .toList();

          // Apply limit if provided and API doesn't respect it
          if (limit != null && posts.length > limit) {
            posts = posts.sublist(0, limit);
          }

          return posts;
        } else {
          throw Exception(
              'Invalid response format: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  /// Get single post by slug
  /// GET /site/12/post/{slug}
  Future<NewsModel> getPostBySlug(String slug) async {
    try {
      final response = await _dio.get('/site/12/post/$slug');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          // API returns single item in data array
          final dynamic postData = data['data'];

          // Handle both array and object response
          if (postData is List && postData.isNotEmpty) {
            return NewsModel.fromJson(postData[0] as Map<String, dynamic>);
          } else if (postData is Map<String, dynamic>) {
            return NewsModel.fromJson(postData);
          } else {
            throw Exception('Invalid post data format');
          }
        } else {
          throw Exception(
              'Post not found: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.response != null) {
        if (e.response?.statusCode == 404) {
          throw Exception('Post not found');
        }
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load post: $e');
    }
  }

  /// Get reports list for SPPG
  /// GET /data/pelaporan-tugas-satgas-mbg
  Future<ReportListResponseModel> getReportsSppg() async {
    try {
      final response = await _dio.get('/data/pelaporan-tugas-satgas-mbg');

      log('SPPG Reports response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success') {
          return ReportListResponseModel.fromJson(data);
        } else {
          throw Exception(
              'Invalid response: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load SPPG reports: $e');
    }
  }

  /// Get reports list for IKL Dinkes
  /// GET /data/pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl
  Future<ReportListResponseModel> getReportsIkl() async {
    try {
      final response = await _dio
          .get('/data/pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl');

      log('IKL Reports response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success') {
          return ReportListResponseModel.fromJson(data);
        } else {
          throw Exception(
              'Invalid response: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load IKL reports: $e');
    }
  }

  /// Get reports list for Penerima MBG
  /// GET /data/pelaporan-penerima-mbg
  Future<ReportListResponseModel> getReportsPenerimaMbg() async {
    try {
      final response = await _dio.get('/data/pelaporan-penerima-mbg');

      log('Penerima MBG Reports response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success') {
          return ReportListResponseModel.fromJson(data);
        } else {
          throw Exception(
              'Invalid response: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load Penerima MBG reports: $e');
    }
  }
}
