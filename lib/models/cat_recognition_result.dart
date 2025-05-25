// import 'package:json_annotation/json_annotation.dart';

// part 'cat_recognition_result.g.dart';

// @JsonSerializable()
class CatRecognitionResult {
  final String id;
  final DateTime date;
  // @JsonKey(name: 'image_url')
  final String imageUrl;
  final List<BreedPrediction> predictions;
  // @JsonKey(name: 'user_note')
  final String? userNote;

  const CatRecognitionResult({
    required this.id,
    required this.date,
    required this.imageUrl,
    required this.predictions,
    this.userNote,
  });

  // factory CatRecognitionResult.fromJson(Map<String, dynamic> json) => 
  //     _$CatRecognitionResultFromJson(json);
  // Map<String, dynamic> toJson() => _$CatRecognitionResultToJson(this);
}

// @JsonSerializable()
class BreedPrediction {
  // @JsonKey(name: 'breed_id')
  final String breedId;
  // @JsonKey(name: 'breed_name')
  final String breedName;
  final double confidence;

  const BreedPrediction({
    required this.breedId,
    required this.breedName,
    required this.confidence,
  });

  // factory BreedPrediction.fromJson(Map<String, dynamic> json) => 
  //     _$BreedPredictionFromJson(json);
  // Map<String, dynamic> toJson() => _$BreedPredictionToJson(this);
} 