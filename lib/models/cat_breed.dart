// import 'package:json_annotation/json_annotation.dart';

// part 'cat_breed.g.dart';

// @JsonSerializable()
class CatBreed {
  final String id;
  final String name;
  final List<String> aliases;
  final String origin;
  // @JsonKey(name: 'breed_group')
  final String breedGroup;
  final List<BreedRecognition> recognition;
  final String history;
  final Appearance appearance;
  final Temperament temperament;
  final Care care;
  final Health health;
  // @JsonKey(name: 'breed_standard_links')
  final List<BreedStandardLink> breedStandardLinks;
  // @JsonKey(name: 'fun_facts')
  final List<String> funFacts;
  final List<MediaItem> images;
  final List<MediaItem> videos;
  // @JsonKey(name: 'adoption_resources')
  final List<AdoptionResource> adoptionResources;
  // @JsonKey(name: 'related_breeds')
  final List<String> relatedBreeds;
  final String status;
  // @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;

  const CatBreed({
    required this.id,
    required this.name,
    required this.aliases,
    required this.origin,
    required this.breedGroup,
    required this.recognition,
    required this.history,
    required this.appearance,
    required this.temperament,
    required this.care,
    required this.health,
    required this.breedStandardLinks,
    required this.funFacts,
    required this.images,
    required this.videos,
    required this.adoptionResources,
    required this.relatedBreeds,
    required this.status,
    required this.lastUpdated,
  });

  // factory CatBreed.fromJson(Map<String, dynamic> json) => _$CatBreedFromJson(json);
  // Map<String, dynamic> toJson() => _$CatBreedToJson(this);
}

// @JsonSerializable()
class BreedRecognition {
  final String organization;
  final String status;

  const BreedRecognition({
    required this.organization,
    required this.status,
  });

  // factory BreedRecognition.fromJson(Map<String, dynamic> json) => _$BreedRecognitionFromJson(json);
  // Map<String, dynamic> toJson() => _$BreedRecognitionToJson(this);
}

// @JsonSerializable()
class Appearance {
  // @JsonKey(name: 'body_type')
  final String bodyType;
  // @JsonKey(name: 'weight_range')
  final String weightRange;
  // @JsonKey(name: 'average_height')
  final String averageHeight;
  // @JsonKey(name: 'coat_length')
  final String coatLength;
  // @JsonKey(name: 'coat_colors')
  final List<String> coatColors;
  // @JsonKey(name: 'eye_colors')
  final List<String> eyeColors;
  // @JsonKey(name: 'distinctive_features')
  final List<String> distinctiveFeatures;

  const Appearance({
    required this.bodyType,
    required this.weightRange,
    required this.averageHeight,
    required this.coatLength,
    required this.coatColors,
    required this.eyeColors,
    required this.distinctiveFeatures,
  });

  // factory Appearance.fromJson(Map<String, dynamic> json) => _$AppearanceFromJson(json);
  // Map<String, dynamic> toJson() => _$AppearanceToJson(this);
}

// @JsonSerializable()
class Temperament {
  final String summary;
  // @JsonKey(name: 'activity_level')
  final String activityLevel;
  // @JsonKey(name: 'vocalization_level')
  final String vocalizationLevel;
  // @JsonKey(name: 'affection_level')
  final String affectionLevel;
  final String intelligence;
  // @JsonKey(name: 'social_with_kids')
  final bool socialWithKids;
  // @JsonKey(name: 'social_with_dogs')
  final bool socialWithDogs;
  // @JsonKey(name: 'social_with_cats')
  final bool socialWithCats;
  final String trainability;

  const Temperament({
    required this.summary,
    required this.activityLevel,
    required this.vocalizationLevel,
    required this.affectionLevel,
    required this.intelligence,
    required this.socialWithKids,
    required this.socialWithDogs,
    required this.socialWithCats,
    required this.trainability,
  });

  // factory Temperament.fromJson(Map<String, dynamic> json) => _$TemperamentFromJson(json);
  // Map<String, dynamic> toJson() => _$TemperamentToJson(this);
}

// @JsonSerializable()
class Care {
  // @JsonKey(name: 'grooming_needs')
  final String groomingNeeds;
  final String shedding;
  // @JsonKey(name: 'exercise_needs')
  final String exerciseNeeds;
  // @JsonKey(name: 'dietary_notes')
  final String dietaryNotes;

  const Care({
    required this.groomingNeeds,
    required this.shedding,
    required this.exerciseNeeds,
    required this.dietaryNotes,
  });

  // factory Care.fromJson(Map<String, dynamic> json) => _$CareFromJson(json);
  // Map<String, dynamic> toJson() => _$CareToJson(this);
}

// @JsonSerializable()
class Health {
  final String lifespan;
  // @JsonKey(name: 'common_issues')
  final List<String> commonIssues;
  // @JsonKey(name: 'genetic_tests')
  final List<String> geneticTests;
  // @JsonKey(name: 'veterinary_recommendations')
  final String veterinaryRecommendations;

  const Health({
    required this.lifespan,
    required this.commonIssues,
    required this.geneticTests,
    required this.veterinaryRecommendations,
  });

  // factory Health.fromJson(Map<String, dynamic> json) => _$HealthFromJson(json);
  // Map<String, dynamic> toJson() => _$HealthToJson(this);
}

// @JsonSerializable()
class BreedStandardLink {
  final String organization;
  final String url;

  const BreedStandardLink({
    required this.organization,
    required this.url,
  });

  // factory BreedStandardLink.fromJson(Map<String, dynamic> json) => _$BreedStandardLinkFromJson(json);
  // Map<String, dynamic> toJson() => _$BreedStandardLinkToJson(this);
}

// @JsonSerializable()
class MediaItem {
  final String url;
  final String caption;
  // @JsonKey(name: 'media_type')
  final String? mediaType;
  // @JsonKey(name: 'upload_date')
  final DateTime? uploadDate;

  const MediaItem({
    required this.url,
    required this.caption,
    this.mediaType,
    this.uploadDate,
  });

  // factory MediaItem.fromJson(Map<String, dynamic> json) => _$MediaItemFromJson(json);
  // Map<String, dynamic> toJson() => _$MediaItemToJson(this);
}

// @JsonSerializable()
class AdoptionResource {
  final String name;
  final String url;
  final String? description;

  const AdoptionResource({
    required this.name,
    required this.url,
    this.description,
  });

  // factory AdoptionResource.fromJson(Map<String, dynamic> json) => _$AdoptionResourceFromJson(json);
  // Map<String, dynamic> toJson() => _$AdoptionResourceToJson(this);
} 