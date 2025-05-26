import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/cat_breed.dart';
import '../models/cat_fact.dart';

class ApiService {
  static const String _catApiBaseUrl = 'https://api.thecatapi.com/v1';
  static const String _catFactsApiUrl = 'https://meowfacts.herokuapp.com'; // Kept for reference, but fetchRandomFacts will change
  static const String _catNinjaFactUrl = 'https://catfact.ninja/fact';
  static const String _catNinjaFactsListUrl = 'https://catfact.ninja/facts';
  
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
    // This method will now primarily fetch one random fact using the new ninja API.
    // For multiple facts, the FactsScreen will use fetchNinjaFactsList directly.
    if (count <= 0) {
      return []; // Or throw an argument error
    }
    try {
      // For simplicity, if count is 1, fetch a single fact.
      // If count > 1, the issue implies the main list will use fetchNinjaFactsList.
      // This method can be simplified to always fetch one, or adapted.
      // Let's stick to the plan: if count is 1, call fetchNinjaFact.
      // If count > 1, call fetchNinjaFactsList.
      if (count == 1) {
        final fact = await fetchNinjaFact();
        return [fact];
      } else {
        // Fetching multiple "random" facts isn't directly supported by a single endpoint that guarantees randomness for each.
        // catfact.ninja/facts provides a list, but it's paginated, not purely random items for a given count.
        // For now, let's fetch 'count' facts from the first page of the list.
        final result = await fetchNinjaFactsList(limit: count, page: 1);
        return result['facts'] as List<CatFact>;
      }
    } on ApiException { // Re-throw if it's already an ApiException
      rethrow;
    } catch (e) { // Catch other potential errors
      throw ApiException('Failed to fetch random facts: ${e.toString()}');
    }
  }

  // New method for a single fact from catfact.ninja
  Future<CatFact> fetchNinjaFact() async {
    try {
      final response = await Dio().get(_catNinjaFactUrl); // Use a new Dio instance or a configured one
      return CatFact.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException('Failed to fetch ninja fact: ${e.message}');
    } catch (e) {
      throw ApiException('An unexpected error occurred while fetching ninja fact: $e');
    }
  }

  // New method for a list of facts from catfact.ninja
  Future<Map<String, dynamic>> fetchNinjaFactsList({int page = 1, int limit = 10}) async {
    try {
      final response = await Dio().get(
        _catNinjaFactsListUrl,
        queryParameters: {'page': page, 'limit': limit},
      );
      final List<dynamic> factsJson = response.data['data'];
      final List<CatFact> facts = factsJson.map((json) => CatFact.fromJson(json)).toList();
      
      // Prepare pagination data (extract what's needed)
      final paginationData = Map<String, dynamic>.from(response.data);
      paginationData.remove('data'); // Remove the facts list itself from pagination data

      return {
        'facts': facts,
        'pagination': paginationData,
      };
    } on DioException catch (e) {
      throw ApiException('Failed to fetch ninja facts list: ${e.message}');
    } catch (e) {
      throw ApiException('An unexpected error occurred while fetching ninja facts list: $e');
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