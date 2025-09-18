import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cat_recognition_result.dart';
import '../utils/result.dart';

class OpenAIService {
  static const String _defaultModel = 'gpt-4o';
  static const int _maxTokens = 1000;
  static const double _temperature = 0.1; // Low temperature for consistent results
  
  final Dio _dio;
  final String _apiKey;
  final String _baseUrl;
  final String _model;

  OpenAIService._({
    required String apiKey,
    required String baseUrl,
    required String model,
  }) : _apiKey = apiKey,
       _baseUrl = baseUrl,
       _model = model,
       _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _dio.options.headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };
    
    _dio.interceptors.add(LogInterceptor(
      requestBody: false, // Don't log image data
      responseBody: true,
      logPrint: (obj) => print('[OpenAI] $obj'),
    ));
  }

  /// Factory constructor to create OpenAI service with environment configuration
  static Future<Result<OpenAIService>> create() async {
    try {
      // Load environment variables
      await dotenv.load(fileName: '.env');
      
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      final baseUrl = dotenv.env['OPENAI_BASE_URL'] ?? 'https://api.openai.com/v1';
      final model = dotenv.env['OPENAI_MODEL'] ?? _defaultModel;
      
      if (apiKey == null || apiKey.isEmpty) {
        return Result.error(AppError(
          message: 'OpenAI API key not found in environment configuration',
          code: 'CONFIGURATION_ERROR',
        ));
      }
      
      final service = OpenAIService._(
        apiKey: apiKey,
        baseUrl: baseUrl,
        model: model,
      );
      
      return Result.success(service);
    } catch (e, stackTrace) {
      return Result.error(AppError(
        message: 'Failed to initialize OpenAI service: $e',
        originalError: e,
        stackTrace: stackTrace,
        code: 'INITIALIZATION_ERROR',
      ));
    }
  }

  /// Analyze cat image and return breed predictions
  Future<Result<List<BreedPrediction>>> analyzeCatImage(File imageFile) async {
    try {
      // Encode image to base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      final mimeType = _getMimeType(imageFile.path);
      
      // Prepare the request payload
      final payload = {
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': _buildPrompt(),
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:$mimeType;base64,$base64Image',
                  'detail': 'high', // Use high detail for better recognition
                },
              },
            ],
          },
        ],
        'max_tokens': _maxTokens,
        'temperature': _temperature,
      };

      // Make API request
      final response = await _dio.post('/chat/completions', data: payload);
      
      // Parse response
      final responseData = response.data as Map<String, dynamic>;
      final choices = responseData['choices'] as List<dynamic>;
      
      if (choices.isEmpty) {
        return Result.error(AppError(
          message: 'No response from OpenAI API',
          code: 'API_ERROR',
        ));
      }
      
      final messageContent = choices[0]['message']['content'] as String;
      
      // Parse the JSON response from the AI
      final predictions = _parseAIResponse(messageContent);
      return Result.success(predictions);
      
    } on DioException catch (e) {
      return Result.error(_handleDioException(e));
    } catch (e, stackTrace) {
      return Result.error(AppError(
        message: 'Failed to analyze image: $e',
        originalError: e,
        stackTrace: stackTrace,
        code: 'ANALYSIS_ERROR',
      ));
    }
  }

  /// Build the prompt for cat breed recognition
  String _buildPrompt() {
    return '''
Analyze this image and identify the cat breed(s) present. You are an expert cat breed identification system with extensive knowledge of feline breeds, their characteristics, care requirements, and history.

Return your response as a comprehensive JSON object with detailed breed information:

{
  "cat_detected": true/false,
  "predictions": [
    {
      "breed_id": "breed_identifier_in_snake_case",
      "breed_name": "Human Readable Breed Name",
      "confidence": 0.85,
      "basic_info": {
        "origin_country": "Country Name",
        "breed_group": "Group Classification (e.g., Natural, Hybrid, Mutation)",
        "size": "Small/Medium/Large",
        "weight_range": "X-Y lbs (X-Y kg)"
      },
      "physical_characteristics": {
        "coat_type": "Short/Long/Semi-long/Hairless",
        "coat_colors": ["Primary colors commonly seen"],
        "coat_patterns": ["Common patterns like solid, tabby, pointed, etc."],
        "eye_colors": ["Typical eye colors for this breed"],
        "distinctive_features": ["Key physical traits that identify this breed"]
      },
      "temperament": {
        "energy_level": "Low/Moderate/High",
        "sociability": "Low/Moderate/High",
        "intelligence": "Average/Above Average/High",
        "personality_traits": ["Key behavioral characteristics"],
        "good_with_children": true/false,
        "good_with_pets": true/false
      },
      "care_requirements": {
        "grooming_needs": "Low/Moderate/High",
        "exercise_requirements": "Low/Moderate/High",
        "dietary_considerations": ["Special dietary needs if any"],
        "common_health_issues": ["Breed-specific health concerns to monitor"]
      },
      "history_background": {
        "development_history": "Brief history of how the breed was developed",
        "original_purpose": "What the breed was originally developed for",
        "interesting_facts": ["Notable facts about the breed"]
      },
      "recognition_status": {
        "cfa_recognized": true/false,
        "tica_recognized": true/false,
        "fife_recognized": true/false,
        "other_registries": ["Other major registries that recognize this breed"]
      }
    }
  ]
}

Requirements:
1. If no cat is detected, set "cat_detected" to false and return empty predictions array
2. Provide up to 3 breed predictions ordered by confidence (highest first)
3. Use confidence scores between 0.0 and 1.0 - be conservative, only use >0.8 when very certain
4. Provide comprehensive, accurate information for each identified breed
5. Use standard breed names and snake_case for breed_id

Return only the JSON object, no additional text.
''';
  }

  /// Helper function to convert various types to bool
  bool _boolFromJson(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    if (value is int) return value != 0;
    return false;
  }

  /// Helper function to convert various types to double
  double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  /// Parse AI response and convert to BreedPrediction objects
  List<BreedPrediction> _parseAIResponse(String responseContent) {
    try {
      // Clean the response content (remove any markdown formatting)
      String cleanContent = responseContent.trim();
      if (cleanContent.startsWith('```json')) {
        cleanContent = cleanContent.substring(7);
      }
      if (cleanContent.endsWith('```')) {
        cleanContent = cleanContent.substring(0, cleanContent.length - 3);
      }
      cleanContent = cleanContent.trim();
      
      final jsonResponse = json.decode(cleanContent) as Map<String, dynamic>;
      
      // Check if cat was detected
      final catDetected = _boolFromJson(jsonResponse['cat_detected']);
      if (!catDetected) {
        return []; // Return empty list if no cat detected
      }
      
      // Parse predictions
      final predictionsJson = jsonResponse['predictions'] as List<dynamic>? ?? [];
      
      return predictionsJson.map((predictionJson) {
        try {
          final prediction = predictionJson as Map<String, dynamic>;
          print('[OpenAI] Processing prediction: ${prediction.keys}');

          return BreedPrediction(
            breedId: prediction['breed_id'] as String,
            breedName: prediction['breed_name'] as String,
            confidence: _doubleFromJson(prediction['confidence']),
            basicInfo: prediction['basic_info'] != null
                ? BasicInfo.fromJson(prediction['basic_info'] as Map<String, dynamic>)
                : null,
            physicalCharacteristics: prediction['physical_characteristics'] != null
                ? PhysicalCharacteristics.fromJson(prediction['physical_characteristics'] as Map<String, dynamic>)
                : null,
            temperament: prediction['temperament'] != null
                ? Temperament.fromJson(prediction['temperament'] as Map<String, dynamic>)
                : null,
            careRequirements: prediction['care_requirements'] != null
                ? CareRequirements.fromJson(prediction['care_requirements'] as Map<String, dynamic>)
                : null,
            historyBackground: prediction['history_background'] != null
                ? HistoryBackground.fromJson(prediction['history_background'] as Map<String, dynamic>)
                : null,
            recognitionStatus: prediction['recognition_status'] != null
                ? RecognitionStatus.fromJson(prediction['recognition_status'] as Map<String, dynamic>)
                : null,
          );
        } catch (e, stackTrace) {
          print('[OpenAI] Error processing individual prediction: $e');
          print('[OpenAI] Stack trace: $stackTrace');
          print('[OpenAI] Prediction data: $predictionJson');
          rethrow;
        }
      }).toList();
      
    } catch (e, stackTrace) {
      print('[OpenAI] Failed to parse AI response: $e');
      print('[OpenAI] Stack trace: $stackTrace');
      print('[OpenAI] Response content: $responseContent');

      // Return empty list if parsing fails
      return [];
    }
  }

  /// Get MIME type from file extension
  String _getMimeType(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // Default fallback
    }
  }

  /// Handle Dio exceptions and convert to AppError
  AppError _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(
          message: 'Request timeout. Please check your internet connection.',
          code: 'NETWORK_ERROR',
          originalError: e,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        
        if (statusCode == 401) {
          return AppError(
            message: 'Invalid OpenAI API key. Please check your configuration.',
            code: 'AUTHENTICATION_ERROR',
            originalError: e,
          );
        } else if (statusCode == 429) {
          return AppError(
            message: 'Rate limit exceeded. Please try again later.',
            code: 'RATE_LIMIT_ERROR',
            originalError: e,
          );
        } else if (statusCode == 400) {
          return AppError(
            message: 'Invalid request. The image may be too large or in an unsupported format.',
            code: 'VALIDATION_ERROR',
            originalError: e,
          );
        } else {
          return AppError(
            message: 'OpenAI API error: ${responseData ?? 'Unknown error'}',
            code: 'API_ERROR',
            originalError: e,
          );
        }
      case DioExceptionType.cancel:
        return AppError(
          message: 'Request was cancelled',
          code: 'CANCELLED_ERROR',
          originalError: e,
        );
      case DioExceptionType.unknown:
      default:
        return AppError(
          message: 'Network error. Please check your internet connection.',
          code: 'NETWORK_ERROR',
          originalError: e,
        );
    }
  }

  /// Dispose resources
  void dispose() {
    _dio.close();
  }
}
