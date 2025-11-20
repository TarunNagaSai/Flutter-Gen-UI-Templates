import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:education_gen_ui/src/models/youtube_search_response.dart';

class YouTubeService {
  late final Dio _dio;
  final String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  late final String _apiKey;

  YouTubeService() {
    _apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? '';
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  /// Search for videos on YouTube
  ///
  /// [query] - The search query
  /// [maxResults] - Maximum number of results to return (default: 5, max: 50)
  /// [pageToken] - Token for pagination
  /// [type] - Type of resource to search for (default: 'video')
  /// [part] - The part parameter specifies a comma-separated list of one or more search resource properties
  Future<YouTubeSearchResponse> searchVideos({
    required String query,
    int maxResults = 5,
    String? pageToken,
    String type = 'video',
    String part = 'snippet',
  }) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'part': part,
          'q': query,
          'type': type,
          'key': _apiKey,
          'maxResults': maxResults,
          if (pageToken != null) 'pageToken': pageToken,
        },
      );

      if (response.statusCode == 200) {
        return YouTubeSearchResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load videos: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data['error']?['message'] ??
            'Unknown error occurred';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception('An unexpected error occurred: ${error.message}');
    }
  }

  /// Close the Dio client
  void dispose() {
    _dio.close();
  }
}
