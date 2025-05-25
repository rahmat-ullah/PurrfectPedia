import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../models/cat_recognition_result.dart';

class RecognitionService {
  static const int _inputSize = 224;
  static const double _confidenceThreshold = 0.1;

  // Mock breed labels - in a real app, this would come from the ML model
  static const List<String> _breedLabels = [
    'maine_coon',
    'persian',
    'siamese',
    'british_shorthair',
    'ragdoll',
    'bengal',
    'abyssinian',
    'russian_blue',
    'scottish_fold',
    'sphynx',
    'norwegian_forest',
    'american_shorthair',
    'exotic_shorthair',
    'birman',
    'oriental_shorthair',
  ];

  static const Map<String, String> _breedNames = {
    'maine_coon': 'Maine Coon',
    'persian': 'Persian',
    'siamese': 'Siamese',
    'british_shorthair': 'British Shorthair',
    'ragdoll': 'Ragdoll',
    'bengal': 'Bengal',
    'abyssinian': 'Abyssinian',
    'russian_blue': 'Russian Blue',
    'scottish_fold': 'Scottish Fold',
    'sphynx': 'Sphynx',
    'norwegian_forest': 'Norwegian Forest Cat',
    'american_shorthair': 'American Shorthair',
    'exotic_shorthair': 'Exotic Shorthair',
    'birman': 'Birman',
    'oriental_shorthair': 'Oriental Shorthair',
  };

  // Initialize the ML model (placeholder for TensorFlow Lite)
  Future<void> initializeModel() async {
    // TODO: Load TensorFlow Lite model
    // interpreter = await Interpreter.fromAsset('assets/ml_models/cat_breed_classifier.tflite');
    print('Recognition model initialized');
  }

  // Preprocess image for ML model
  Uint8List _preprocessImage(File imageFile) {
    // Read and decode image
    final bytes = imageFile.readAsBytesSync();
    img.Image? image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize image to model input size
    image = img.copyResize(image, width: _inputSize, height: _inputSize);

    // Convert to RGB and normalize
    final input = Float32List(_inputSize * _inputSize * 3);
    int pixelIndex = 0;
    
    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        final pixel = image.getPixel(x, y);
        // Use the new API for getting color components
        input[pixelIndex++] = (pixel.r / 255.0);
        input[pixelIndex++] = (pixel.g / 255.0);
        input[pixelIndex++] = (pixel.b / 255.0);
      }
    }

    return input.buffer.asUint8List();
  }

  // Run inference on the image
  Future<List<BreedPrediction>> recognizeBreed(File imageFile) async {
    try {
      // Preprocess image
      final input = _preprocessImage(imageFile);

      // TODO: Run actual ML inference
      // For now, return mock predictions
      final predictions = _generateMockPredictions();

      // Filter predictions by confidence threshold
      final filteredPredictions = predictions
          .where((p) => p.confidence >= _confidenceThreshold)
          .toList();

      // Sort by confidence (highest first)
      filteredPredictions.sort((a, b) => b.confidence.compareTo(a.confidence));

      // Return top 3 predictions
      return filteredPredictions.take(3).toList();
    } catch (e) {
      throw RecognitionException('Failed to recognize breed: $e');
    }
  }

  // Generate mock predictions for testing
  List<BreedPrediction> _generateMockPredictions() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final predictions = <BreedPrediction>[];

    // Generate random predictions for demonstration
    for (int i = 0; i < 5; i++) {
      final breedIndex = (random + i) % _breedLabels.length;
      final breedId = _breedLabels[breedIndex];
      final breedName = _breedNames[breedId]!;
      final confidence = (0.9 - (i * 0.15)).clamp(0.1, 1.0);

      predictions.add(BreedPrediction(
        breedId: breedId,
        breedName: breedName,
        confidence: confidence,
      ));
    }

    return predictions;
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
    // TODO: Dispose TensorFlow Lite interpreter
    print('Recognition service disposed');
  }
}

class RecognitionException implements Exception {
  final String message;
  
  RecognitionException(this.message);
  
  @override
  String toString() => 'RecognitionException: $message';
} 