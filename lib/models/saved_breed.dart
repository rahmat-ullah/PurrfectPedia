import 'package:json_annotation/json_annotation.dart';

part 'saved_breed.g.dart';

// Helper function to convert various types to bool (for SQLite compatibility)
bool _boolFromJson(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  return false;
}

// Helper function to convert various types to int (for SQLite compatibility)
int _intFromJson(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

@JsonSerializable()
class SavedBreed {
  final String id;
  @JsonKey(name: 'breed_id')
  final String breedId;
  @JsonKey(name: 'breed_name')
  final String breedName;
  final double confidence;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'saved_date')
  final DateTime savedDate;
  @JsonKey(name: 'recognition_id')
  final String recognitionId;
  final String? notes;

  const SavedBreed({
    required this.id,
    required this.breedId,
    required this.breedName,
    required this.confidence,
    this.imageUrl,
    required this.savedDate,
    required this.recognitionId,
    this.notes,
  });

  factory SavedBreed.fromJson(Map<String, dynamic> json) =>
      _$SavedBreedFromJson(json);
  Map<String, dynamic> toJson() => _$SavedBreedToJson(this);
}

@JsonSerializable()
class RecognitionHistory {
  final String id;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'recognition_date')
  final DateTime recognitionDate;
  @JsonKey(name: 'was_successful')
  final bool wasSuccessful;
  @JsonKey(name: 'breeds_detected')
  final int breedsDetected;
  @JsonKey(name: 'highest_confidence')
  final double? highestConfidence;
  @JsonKey(name: 'top_breed_name')
  final String? topBreedName;
  final String? notes;

  const RecognitionHistory({
    required this.id,
    required this.imageUrl,
    required this.recognitionDate,
    required this.wasSuccessful,
    required this.breedsDetected,
    this.highestConfidence,
    this.topBreedName,
    this.notes,
  });

  factory RecognitionHistory.fromJson(Map<String, dynamic> json) {
    return RecognitionHistory(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      recognitionDate: DateTime.parse(json['recognition_date'] as String),
      wasSuccessful: _boolFromJson(json['was_successful']),
      breedsDetected: _intFromJson(json['breeds_detected']),
      highestConfidence: json['highest_confidence'] != null
          ? (json['highest_confidence'] is String
              ? double.tryParse(json['highest_confidence'])
              : (json['highest_confidence'] as num?)?.toDouble())
          : null,
      topBreedName: json['top_breed_name'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = _$RecognitionHistoryToJson(this);
    // Convert boolean to integer for SQLite compatibility
    json['was_successful'] = wasSuccessful ? 1 : 0;
    return json;
  }
}

@JsonSerializable()
class UserStats {
  @JsonKey(name: 'total_recognitions')
  final int totalRecognitions;
  @JsonKey(name: 'successful_recognitions')
  final int successfulRecognitions;
  @JsonKey(name: 'breeds_discovered')
  final int breedsDiscovered;
  @JsonKey(name: 'saved_breeds')
  final int savedBreeds;
  @JsonKey(name: 'favorite_breeds')
  final int favoriteBreeds;
  @JsonKey(name: 'last_recognition_date')
  final DateTime? lastRecognitionDate;
  @JsonKey(name: 'member_since')
  final DateTime memberSince;

  const UserStats({
    required this.totalRecognitions,
    required this.successfulRecognitions,
    required this.breedsDiscovered,
    required this.savedBreeds,
    required this.favoriteBreeds,
    this.lastRecognitionDate,
    required this.memberSince,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalRecognitions: _intFromJson(json['total_recognitions']),
      successfulRecognitions: _intFromJson(json['successful_recognitions']),
      breedsDiscovered: _intFromJson(json['breeds_discovered']),
      savedBreeds: _intFromJson(json['saved_breeds']),
      favoriteBreeds: _intFromJson(json['favorite_breeds']),
      lastRecognitionDate: json['last_recognition_date'] != null
          ? DateTime.parse(json['last_recognition_date'] as String)
          : null,
      memberSince: DateTime.parse(json['member_since'] as String),
    );
  }
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  double get successRate {
    if (totalRecognitions == 0) return 0.0;
    return successfulRecognitions / totalRecognitions;
  }
}

@JsonSerializable()
class DailyCatQuote {
  final String id;
  final String quote;
  final String? author;
  final String category;
  final DateTime date;
  @JsonKey(name: 'is_educational')
  final bool isEducational;

  const DailyCatQuote({
    required this.id,
    required this.quote,
    this.author,
    required this.category,
    required this.date,
    required this.isEducational,
  });

  factory DailyCatQuote.fromJson(Map<String, dynamic> json) {
    return DailyCatQuote(
      id: json['id'] as String,
      quote: json['quote'] as String,
      author: json['author'] as String?,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      isEducational: _boolFromJson(json['is_educational']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = _$DailyCatQuoteToJson(this);
    // Convert boolean to integer for SQLite compatibility
    json['is_educational'] = isEducational ? 1 : 0;
    return json;
  }
}
