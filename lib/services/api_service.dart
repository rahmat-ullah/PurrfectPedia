import 'package:dio/dio.dart';
import '../models/simple_cat_breed.dart';
import '../models/cat_fact.dart';
import '../utils/result.dart';

class ApiService {
  static const String _catApiBaseUrl = 'https://api.thecatapi.com/v1';
  static const String _catFactsApiUrl = 'https://catfact.ninja';
  
  final Dio _dio;

  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = _catApiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  // Fetch all cat breeds
  Future<Result<List<SimpleCatBreed>>> fetchBreeds() async {
    try {
      final response = await _dio.get('/breeds');
      final List<dynamic> breedsJson = response.data;

      // Now with working JSON serialization
      final breeds = breedsJson.map((json) => SimpleCatBreed.fromJson(json)).toList();
      return Result.success(breeds);
    } on DioException catch (e) {
      return Result.error(_handleDioException(e, 'Failed to fetch breeds'));
    } catch (e, stackTrace) {
      return Result.error(AppError(
        message: 'Unexpected error while fetching breeds: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  // Fetch breed by ID
  Future<Result<SimpleCatBreed?>> fetchBreedById(String breedId) async {
    try {
      final response = await _dio.get('/breeds/$breedId');
      final breed = SimpleCatBreed.fromJson(response.data);
      return Result.success(breed);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Result.success(null);
      }
      return Result.error(_handleDioException(e, 'Failed to fetch breed'));
    } catch (e, stackTrace) {
      return Result.error(AppError(
        message: 'Unexpected error while fetching breed: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  // Search breeds by name
  Future<Result<List<SimpleCatBreed>>> searchBreeds(String query) async {
    try {
      final response = await _dio.get('/breeds/search', queryParameters: {
        'q': query,
      });
      final List<dynamic> breedsJson = response.data;

      final breeds = breedsJson.map((json) => SimpleCatBreed.fromJson(json)).toList();
      return Result.success(breeds);
    } on DioException catch (e) {
      return Result.error(_handleDioException(e, 'Failed to search breeds'));
    } catch (e, stackTrace) {
      return Result.error(AppError(
        message: 'Unexpected error while searching breeds: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  // Fetch breed images
  Future<List<String>> fetchBreedImages(String breedId, {int limit = 10}) async {
    try {
      final response = await _dio.get('/images/search', queryParameters: {
        'breed_ids': breedId,
        'limit': limit,
        'size': 'med',
      });
      
      final List<dynamic> imagesJson = response.data;
      return imagesJson.map((json) => json['url'] as String).toList();
    } on DioException catch (e) {
      throw ApiException('Failed to fetch breed images: ${e.message}');
    }
  }

  // Fetch random cat facts
  Future<List<CatFact>> fetchRandomFacts({int count = 1}) async {
    try {
      final response = await Dio().get(
        '$_catFactsApiUrl/?count=$count',
      );
      
      final List<dynamic> factsJson = response.data['data'];
      return factsJson.asMap().entries.map((entry) {
        final index = entry.key;
        final factText = entry.value as String;
        
        return CatFact(
          id: 'fact_${DateTime.now().millisecondsSinceEpoch}_$index',
          factText: factText,
          category: 'General',
          dateAdded: DateTime.now(),
        );
      }).toList();
    } on DioException catch (e) {
      throw ApiException('Failed to fetch cat facts: ${e.message}');
    }
  }

  // Upload image for breed recognition
  Future<String> uploadImageForRecognition(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post('/images/upload', data: formData);
      return response.data['url'];
    } on DioException catch (e) {
      throw ApiException('Failed to upload image: ${e.message}');
    }
  }

  // Fetch single random cat fact from catfact.ninja
  Future<Result<CatFact>> fetchRandomFact() async {
    try {
      final response = await Dio().get('$_catFactsApiUrl/fact');

      final fact = CatFact(
        id: 'fact_${DateTime.now().millisecondsSinceEpoch}',
        factText: response.data['fact'],
        category: 'General',
        dateAdded: DateTime.now(),
      );
      return Result.success(fact);
    } on DioException catch (e) {
      return Result.error(_handleDioException(e, 'Failed to fetch random cat fact'));
    } catch (e, stackTrace) {
      return Result.error(AppError(
        message: 'Unexpected error while fetching random fact: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  // Fetch paginated cat facts from catfact.ninja
  Future<Map<String, dynamic>> fetchFactsList({int page = 1, int limit = 10}) async {
    try {
      final response = await Dio().get(
        '$_catFactsApiUrl/facts',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      
      final data = response.data;
      final List<dynamic> factsJson = data['data'];
      
      final facts = factsJson.map((factData) {
        return CatFact(
          id: 'fact_${DateTime.now().millisecondsSinceEpoch}_${factData['fact'].hashCode}',
          factText: factData['fact'],
          category: 'General',
          dateAdded: DateTime.now(),
        );
      }).toList();
      
      return {
        'facts': facts,
        'currentPage': data['current_page'],
        'lastPage': data['last_page'],
        'total': data['total'],
        'hasNextPage': data['current_page'] < data['last_page'],
      };
    } on DioException catch (e) {
      throw ApiException('Failed to fetch cat facts list: ${e.message}');
    }
  }

  // Helper method to convert DioException to AppError
  AppError _handleDioException(DioException e, String context) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkError(
          message: '$context: Connection timeout',
          code: 'TIMEOUT',
          originalError: e,
        );
      case DioExceptionType.connectionError:
        return NetworkError(
          message: '$context: No internet connection',
          code: 'NO_CONNECTION',
          originalError: e,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        return ApiError(
          message: '$context: Server error (${statusCode ?? 'Unknown'})',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
          originalError: e,
        );
      case DioExceptionType.cancel:
        return AppError(
          message: '$context: Request was cancelled',
          code: 'CANCELLED',
          originalError: e,
        );
      case DioExceptionType.unknown:
      default:
        return AppError(
          message: '$context: ${e.message ?? 'Unknown error'}',
          code: 'UNKNOWN',
          originalError: e,
        );
    }
  }
}

class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}