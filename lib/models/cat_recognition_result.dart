import 'package:json_annotation/json_annotation.dart';

part 'cat_recognition_result.g.dart';

// Helper function to convert various types to bool
bool _boolFromJson(dynamic value) {
  if (value is bool) return value;
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  if (value is int) return value != 0;
  return false;
}

@JsonSerializable()
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

  factory CatRecognitionResult.fromJson(Map<String, dynamic> json) =>
      _$CatRecognitionResultFromJson(json);
  Map<String, dynamic> toJson() => _$CatRecognitionResultToJson(this);
}

@JsonSerializable()
class BreedPrediction {
  @JsonKey(name: 'breed_id')
  final String breedId;
  @JsonKey(name: 'breed_name')
  final String breedName;
  final double confidence;

  // Comprehensive breed information
  @JsonKey(name: 'basic_info')
  final BasicInfo? basicInfo;
  @JsonKey(name: 'physical_characteristics')
  final PhysicalCharacteristics? physicalCharacteristics;
  final Temperament? temperament;
  @JsonKey(name: 'care_requirements')
  final CareRequirements? careRequirements;
  @JsonKey(name: 'history_background')
  final HistoryBackground? historyBackground;
  @JsonKey(name: 'recognition_status')
  final RecognitionStatus? recognitionStatus;

  const BreedPrediction({
    required this.breedId,
    required this.breedName,
    required this.confidence,
    this.basicInfo,
    this.physicalCharacteristics,
    this.temperament,
    this.careRequirements,
    this.historyBackground,
    this.recognitionStatus,
  });

  factory BreedPrediction.fromJson(Map<String, dynamic> json) =>
      _$BreedPredictionFromJson(json);
  Map<String, dynamic> toJson() => _$BreedPredictionToJson(this);
}

@JsonSerializable()
class BasicInfo {
  @JsonKey(name: 'origin_country')
  final String originCountry;
  @JsonKey(name: 'breed_group')
  final String breedGroup;
  final String size;
  @JsonKey(name: 'weight_range')
  final String weightRange;

  const BasicInfo({
    required this.originCountry,
    required this.breedGroup,
    required this.size,
    required this.weightRange,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) =>
      _$BasicInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BasicInfoToJson(this);
}

@JsonSerializable()
class PhysicalCharacteristics {
  @JsonKey(name: 'coat_type')
  final String coatType;
  @JsonKey(name: 'coat_colors')
  final List<String> coatColors;
  @JsonKey(name: 'coat_patterns')
  final List<String> coatPatterns;
  @JsonKey(name: 'eye_colors')
  final List<String> eyeColors;
  @JsonKey(name: 'distinctive_features')
  final List<String> distinctiveFeatures;

  const PhysicalCharacteristics({
    required this.coatType,
    required this.coatColors,
    required this.coatPatterns,
    required this.eyeColors,
    required this.distinctiveFeatures,
  });

  factory PhysicalCharacteristics.fromJson(Map<String, dynamic> json) =>
      _$PhysicalCharacteristicsFromJson(json);
  Map<String, dynamic> toJson() => _$PhysicalCharacteristicsToJson(this);
}

@JsonSerializable()
class Temperament {
  @JsonKey(name: 'energy_level')
  final String energyLevel;
  final String sociability;
  final String intelligence;
  @JsonKey(name: 'personality_traits')
  final List<String> personalityTraits;
  @JsonKey(name: 'good_with_children')
  final bool goodWithChildren;
  @JsonKey(name: 'good_with_pets')
  final bool goodWithPets;

  const Temperament({
    required this.energyLevel,
    required this.sociability,
    required this.intelligence,
    required this.personalityTraits,
    required this.goodWithChildren,
    required this.goodWithPets,
  });

  factory Temperament.fromJson(Map<String, dynamic> json) {
    return Temperament(
      energyLevel: json['energy_level'] as String,
      sociability: json['sociability'] as String,
      intelligence: json['intelligence'] as String,
      personalityTraits: (json['personality_traits'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      goodWithChildren: _boolFromJson(json['good_with_children']),
      goodWithPets: _boolFromJson(json['good_with_pets']),
    );
  }

  Map<String, dynamic> toJson() => _$TemperamentToJson(this);
}

@JsonSerializable()
class CareRequirements {
  @JsonKey(name: 'grooming_needs')
  final String groomingNeeds;
  @JsonKey(name: 'exercise_requirements')
  final String exerciseRequirements;
  @JsonKey(name: 'dietary_considerations')
  final List<String> dietaryConsiderations;
  @JsonKey(name: 'common_health_issues')
  final List<String> commonHealthIssues;

  const CareRequirements({
    required this.groomingNeeds,
    required this.exerciseRequirements,
    required this.dietaryConsiderations,
    required this.commonHealthIssues,
  });

  factory CareRequirements.fromJson(Map<String, dynamic> json) =>
      _$CareRequirementsFromJson(json);
  Map<String, dynamic> toJson() => _$CareRequirementsToJson(this);
}

@JsonSerializable()
class HistoryBackground {
  @JsonKey(name: 'development_history')
  final String developmentHistory;
  @JsonKey(name: 'original_purpose')
  final String originalPurpose;
  @JsonKey(name: 'interesting_facts')
  final List<String> interestingFacts;

  const HistoryBackground({
    required this.developmentHistory,
    required this.originalPurpose,
    required this.interestingFacts,
  });

  factory HistoryBackground.fromJson(Map<String, dynamic> json) =>
      _$HistoryBackgroundFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryBackgroundToJson(this);
}

@JsonSerializable()
class RecognitionStatus {
  @JsonKey(name: 'cfa_recognized')
  final bool cfaRecognized;
  @JsonKey(name: 'tica_recognized')
  final bool ticaRecognized;
  @JsonKey(name: 'fife_recognized')
  final bool fifeRecognized;
  @JsonKey(name: 'other_registries')
  final List<String> otherRegistries;

  const RecognitionStatus({
    required this.cfaRecognized,
    required this.ticaRecognized,
    required this.fifeRecognized,
    required this.otherRegistries,
  });

  factory RecognitionStatus.fromJson(Map<String, dynamic> json) {
    return RecognitionStatus(
      cfaRecognized: _boolFromJson(json['cfa_recognized']),
      ticaRecognized: _boolFromJson(json['tica_recognized']),
      fifeRecognized: _boolFromJson(json['fife_recognized']),
      otherRegistries: (json['other_registries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => _$RecognitionStatusToJson(this);
}