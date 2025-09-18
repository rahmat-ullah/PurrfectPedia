import 'dart:io';
import '../models/cat_recognition_result.dart';
import '../utils/result.dart';
import 'openai_service.dart';

class RecognitionService {
  static const double _confidenceThreshold = 0.1;

  OpenAIService? _openAIService;

  // Initialize the OpenAI service
  Future<void> initializeModel() async {
    try {
      final result = await OpenAIService.create();
      result.when(
        success: (service) {
          _openAIService = service;
          print('Recognition model initialized with OpenAI Vision API');
        },
        onError: (error) {
          print('Failed to initialize OpenAI service: ${error.message}');
          throw RecognitionException('Failed to initialize recognition service: ${error.message}');
        },
        loading: () {
          // This shouldn't happen with the current implementation
        },
      );
    } catch (e) {
      print('Failed to initialize recognition service: $e');
      throw RecognitionException('Failed to initialize recognition service: $e');
    }
  }



  // Run inference on the image using OpenAI Vision API
  Future<List<BreedPrediction>> recognizeBreed(File imageFile) async {
    if (_openAIService == null) {
      throw RecognitionException('Recognition service not initialized. Please call initializeModel() first.');
    }

    try {
      final result = await _openAIService!.analyzeCatImage(imageFile);

      return result.when(
        success: (predictions) {
          // Filter predictions by confidence threshold
          final filteredPredictions = predictions
              .where((p) => p.confidence >= _confidenceThreshold)
              .toList();

          // Sort by confidence (highest first) - should already be sorted by OpenAI
          filteredPredictions.sort((a, b) => b.confidence.compareTo(a.confidence));

          // Return top 3 predictions
          return filteredPredictions.take(3).toList();
        },
        onError: (error) {
          throw RecognitionException('Failed to analyze image: ${error.message}');
        },
        loading: () {
          throw RecognitionException('Unexpected loading state during image analysis');
        },
      );
    } catch (e) {
      if (e is RecognitionException) {
        rethrow;
      }
      throw RecognitionException('Failed to recognize breed: $e');
    }
  }



  // Create recognition result
  CatRecognitionResult createRecognitionResult({
    required String imageUrl,
    required List<BreedPrediction> predictions,
    String? userNote,
  }) {
    return CatRecognitionResult(
      id: 'recognition_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      imageUrl: imageUrl,
      predictions: predictions,
      userNote: userNote,
    );
  }

  // Dispose resources
  void dispose() {
    _openAIService?.dispose();
    _openAIService = null;
    print('Recognition service disposed');
  }
}

class RecognitionException implements Exception {
  final String message;
  
  RecognitionException(this.message);
  
  @override
  String toString() => 'RecognitionException: $message';
} 