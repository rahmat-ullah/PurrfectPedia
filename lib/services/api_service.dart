import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/cat_breed.dart';
import '../models/cat_fact.dart';

class ApiService {
  static const String _catApiBaseUrl = 'https://api.thecatapi.com/v1';
  static const String _catFactsApiUrl = 'https://meowfacts.herokuapp.com';
  
  final Dio _dio;

  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = _catApiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    
    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  // Fetch all cat breeds
  Future<List<CatBreed>> fetchBreeds() async {
    try {
      final response = await _dio.get('/breeds');
      final List<dynamic> breedsJson = response.data;
      
      // TODO: Implement proper JSON parsing when serialization is enabled
      // return breedsJson.map((json) => CatBreed.fromJson(json)).toList();
      
      // For now, return empty list
      return [];
    } on DioException catch (e) {
      throw ApiException('Failed to fetch breeds: ${e.message}');
    }
  }

  // Fetch breed by ID
  Future<CatBreed?> fetchBreedById(String breedId) async {
    try {
      final response = await _dio.get('/breeds/$breedId');
      // TODO: Implement proper JSON parsing when serialization is enabled
      // return CatBreed.fromJson(response.data);
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ApiException('Failed to fetch breed: ${e.message}');
    }
  }

  // Search breeds by name
  Future<List<CatBreed>> searchBreeds(String query) async {
    try {
      final response = await _dio.get('/breeds/search', queryParameters: {
        'q': query,
      });
      final List<dynamic> breedsJson = response.data;
      
      // TODO: Implement proper JSON parsing when serialization is enabled
      // return breedsJson.map((json) => CatBreed.fromJson(json)).toList();
      return [];
    } on DioException catch (e) {
      throw ApiException('Failed to search breeds: ${e.message}');
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
}

class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
} 