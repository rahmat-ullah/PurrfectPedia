import 'package:json_annotation/json_annotation.dart';

part 'breed.g.dart';

@JsonSerializable()
class Breed {
  final String id;
  final String name;
  final List<String> aliases;
  final String origin;
  @JsonKey(name: 'breed_group')
  final String breedGroup;
  @JsonKey(name: 'is_crossbreed')
  final bool isCrossbreed;
  @JsonKey(name: 'crossbreed_info')
  final CrossbreedInfo? crossbreedInfo;
  final List<Recognition> recognition;
  final String history;
  final Appearance appearance;
  final Temperament temperament;
  final Care care;
  final Health health;
  @JsonKey(name: 'common_medications')
  final List<Medication> commonMedications;
  @JsonKey(name: 'veterinary_care_recommendations')
  final VeterinaryCare veterinaryCare;
  @JsonKey(name: 'breeding_compatibility')
  final BreedingCompatibility? breedingCompatibility;
  @JsonKey(name: 'typical_litter_size')
  final LitterSize? typicalLitterSize;
  @JsonKey(name: 'gestation_period_days')
  final GestationPeriod? gestationPeriod;
  @JsonKey(name: 'reproductive_maturity_age')
  final ReproductiveMaturity? reproductiveMaturity;
  @JsonKey(name: 'life_span_years')
  final LifeSpan? lifeSpanYears;
  @JsonKey(name: 'weight_range_lbs')
  final WeightRange? weightRangeLbs;
  @JsonKey(name: 'other_traits')
  final String? otherTraits;
  @JsonKey(name: 'breed_standard_links')
  final List<BreedStandardLink> breedStandardLinks;
  @JsonKey(name: 'fun_facts')
  final List<String> funFacts;
  final List<BreedImage> images;
  final List<BreedVideo> videos;
  @JsonKey(name: 'adoption_resources')
  final List<AdoptionResource> adoptionResources;
  @JsonKey(name: 'related_breeds')
  final List<String> relatedBreeds;
  final String status;
  @JsonKey(name: 'last_updated')
  final String lastUpdated;

  const Breed({
    required this.id,
    required this.name,
    required this.aliases,
    required this.origin,
    required this.breedGroup,
    required this.isCrossbreed,
    this.crossbreedInfo,
    required this.recognition,
    required this.history,
    required this.appearance,
    required this.temperament,
    required this.care,
    required this.health,
    required this.commonMedications,
    required this.veterinaryCare,
    this.breedingCompatibility,
    this.typicalLitterSize,
    this.gestationPeriod,
    this.reproductiveMaturity,
    this.lifeSpanYears,
    this.weightRangeLbs,
    this.otherTraits,
    required this.breedStandardLinks,
    required this.funFacts,
    required this.images,
    required this.videos,
    required this.adoptionResources,
    required this.relatedBreeds,
    required this.status,
    required this.lastUpdated,
  });

  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);
  Map<String, dynamic> toJson() => _$BreedToJson(this);
}

@JsonSerializable()
class CrossbreedInfo {
  @JsonKey(name: 'parent_breeds')
  final List<String> parentBreeds;
  @JsonKey(name: 'parent_breed_ids')
  final List<String> parentBreedIds;
  @JsonKey(name: 'parent_breed_images')
  final List<ParentBreedImage> parentBreedImages;
  final String? generation;
  @JsonKey(name: 'primary_parent')
  final String? primaryParent;
  @JsonKey(name: 'primary_parent_id')
  final String? primaryParentId;
  @JsonKey(name: 'secondary_parent')
  final String? secondaryParent;
  @JsonKey(name: 'secondary_parent_id')
  final String? secondaryParentId;
  @JsonKey(name: 'breeding_purpose')
  final String? breedingPurpose;
  @JsonKey(name: 'first_developed')
  final String? firstDeveloped;
  @JsonKey(name: 'inheritance_patterns')
  final InheritancePatterns? inheritancePatterns;
  @JsonKey(name: 'hybrid_vigor')
  final HybridVigor? hybridVigor;
  @JsonKey(name: 'breed_stability')
  final String? breedStability;
  @JsonKey(name: 'recognition_challenges')
  final List<String> recognitionChallenges;

  const CrossbreedInfo({
    required this.parentBreeds,
    required this.parentBreedIds,
    required this.parentBreedImages,
    this.generation,
    this.primaryParent,
    this.primaryParentId,
    this.secondaryParent,
    this.secondaryParentId,
    this.breedingPurpose,
    this.firstDeveloped,
    this.inheritancePatterns,
    this.hybridVigor,
    this.breedStability,
    required this.recognitionChallenges,
  });

  factory CrossbreedInfo.fromJson(Map<String, dynamic> json) =>
      _$CrossbreedInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CrossbreedInfoToJson(this);
}

@JsonSerializable()
class ParentBreedImage {
  @JsonKey(name: 'breed_id')
  final String breedId;
  @JsonKey(name: 'breed_name')
  final String breedName;
  final List<BreedImage> images;

  const ParentBreedImage({
    required this.breedId,
    required this.breedName,
    required this.images,
  });

  factory ParentBreedImage.fromJson(Map<String, dynamic> json) =>
      _$ParentBreedImageFromJson(json);
  Map<String, dynamic> toJson() => _$ParentBreedImageToJson(this);
}

@JsonSerializable()
class InheritancePatterns {
  @JsonKey(name: 'coat_from')
  final String? coatFrom;
  @JsonKey(name: 'size_from')
  final String? sizeFrom;
  @JsonKey(name: 'temperament_from')
  final String? temperamentFrom;
  @JsonKey(name: 'health_considerations')
  final List<String> healthConsiderations;

  const InheritancePatterns({
    this.coatFrom,
    this.sizeFrom,
    this.temperamentFrom,
    required this.healthConsiderations,
  });

  factory InheritancePatterns.fromJson(Map<String, dynamic> json) =>
      _$InheritancePatternsFromJson(json);
  Map<String, dynamic> toJson() => _$InheritancePatternsToJson(this);
}

@JsonSerializable()
class HybridVigor {
  final bool? present;
  final List<String> benefits;
  @JsonKey(name: 'potential_issues')
  final List<String> potentialIssues;

  const HybridVigor({
    this.present,
    required this.benefits,
    required this.potentialIssues,
  });

  factory HybridVigor.fromJson(Map<String, dynamic> json) =>
      _$HybridVigorFromJson(json);
  Map<String, dynamic> toJson() => _$HybridVigorToJson(this);
}

@JsonSerializable()
class Recognition {
  final String organization;
  final String status;

  const Recognition({
    required this.organization,
    required this.status,
  });

  factory Recognition.fromJson(Map<String, dynamic> json) =>
      _$RecognitionFromJson(json);
  Map<String, dynamic> toJson() => _$RecognitionToJson(this);
}

@JsonSerializable()
class Appearance {
  @JsonKey(name: 'body_type')
  final String bodyType;
  @JsonKey(name: 'weight_range')
  final String weightRange;
  @JsonKey(name: 'average_height')
  final String averageHeight;
  @JsonKey(name: 'coat_length')
  final String coatLength;
  final String coat;
  @JsonKey(name: 'coat_colors')
  final List<String> coatColors;
  final String colors;
  @JsonKey(name: 'eye_colors')
  final List<String> eyeColors;
  final String size;
  @JsonKey(name: 'distinctive_features')
  final List<String> distinctiveFeatures;
  @JsonKey(name: 'distinct_features')
  final List<String> distinctFeatures;

  const Appearance({
    required this.bodyType,
    required this.weightRange,
    required this.averageHeight,
    required this.coatLength,
    required this.coat,
    required this.coatColors,
    required this.colors,
    required this.eyeColors,
    required this.size,
    required this.distinctiveFeatures,
    required this.distinctFeatures,
  });

  factory Appearance.fromJson(Map<String, dynamic> json) =>
      _$AppearanceFromJson(json);
  Map<String, dynamic> toJson() => _$AppearanceToJson(this);
}

@JsonSerializable()
class Temperament {
  final String summary;
  final List<String> traits;
  @JsonKey(name: 'activity_level')
  final String activityLevel;
  @JsonKey(name: 'vocalization_level')
  final String vocalizationLevel;
  @JsonKey(name: 'affection_level')
  final String affectionLevel;
  final String intelligence;
  @JsonKey(name: 'social_with_kids')
  final bool socialWithKids;
  @JsonKey(name: 'social_with_dogs')
  final bool socialWithDogs;
  @JsonKey(name: 'social_with_cats')
  final bool socialWithCats;
  final String trainability;

  const Temperament({
    required this.summary,
    required this.traits,
    required this.activityLevel,
    required this.vocalizationLevel,
    required this.affectionLevel,
    required this.intelligence,
    required this.socialWithKids,
    required this.socialWithDogs,
    required this.socialWithCats,
    required this.trainability,
  });

  factory Temperament.fromJson(Map<String, dynamic> json) =>
      _$TemperamentFromJson(json);
  Map<String, dynamic> toJson() => _$TemperamentToJson(this);
}

@JsonSerializable()
class Care {
  @JsonKey(name: 'grooming_needs')
  final String groomingNeeds;
  final String grooming;
  final String shedding;
  @JsonKey(name: 'exercise_needs')
  final String exerciseNeeds;
  final String exercise;
  @JsonKey(name: 'dietary_notes')
  final String dietaryNotes;
  final String nutrition;

  const Care({
    required this.groomingNeeds,
    required this.grooming,
    required this.shedding,
    required this.exerciseNeeds,
    required this.exercise,
    required this.dietaryNotes,
    required this.nutrition,
  });

  factory Care.fromJson(Map<String, dynamic> json) => _$CareFromJson(json);
  Map<String, dynamic> toJson() => _$CareToJson(this);
}

@JsonSerializable()
class Health {
  final String lifespan;
  @JsonKey(name: 'common_issues')
  final List<String> commonIssues;
  @JsonKey(name: 'genetic_tests')
  final List<String> geneticTests;
  @JsonKey(name: 'veterinary_recommendations')
  final String veterinaryRecommendations;
  final String vaccinations;

  const Health({
    required this.lifespan,
    required this.commonIssues,
    required this.geneticTests,
    required this.veterinaryRecommendations,
    required this.vaccinations,
  });

  factory Health.fromJson(Map<String, dynamic> json) => _$HealthFromJson(json);
  Map<String, dynamic> toJson() => _$HealthToJson(this);
}

@JsonSerializable()
class Medication {
  final String name;
  final String purpose;
  @JsonKey(name: 'usage_notes')
  final String usageNotes;

  const Medication({
    required this.name,
    required this.purpose,
    required this.usageNotes,
  });

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationToJson(this);
}

@JsonSerializable()
class VeterinaryCare {
  @JsonKey(name: 'deworming_schedule')
  final String dewormingSchedule;
  final String vaccinations;
  @JsonKey(name: 'dental_care')
  final String dentalCare;
  @JsonKey(name: 'parasite_prevention')
  final String parasitePrevention;
  @JsonKey(name: 'special_screenings')
  final String specialScreenings;

  const VeterinaryCare({
    required this.dewormingSchedule,
    required this.vaccinations,
    required this.dentalCare,
    required this.parasitePrevention,
    required this.specialScreenings,
  });

  factory VeterinaryCare.fromJson(Map<String, dynamic> json) =>
      _$VeterinaryCareFromJson(json);
  Map<String, dynamic> toJson() => _$VeterinaryCareToJson(this);
}

@JsonSerializable()
class BreedingCompatibility {
  @JsonKey(name: 'compatible_breeds')
  final List<String> compatibleBreeds;
  @JsonKey(name: 'genetic_precautions')
  final List<String> geneticPrecautions;

  const BreedingCompatibility({
    required this.compatibleBreeds,
    required this.geneticPrecautions,
  });

  factory BreedingCompatibility.fromJson(Map<String, dynamic> json) =>
      _$BreedingCompatibilityFromJson(json);
  Map<String, dynamic> toJson() => _$BreedingCompatibilityToJson(this);
}

@JsonSerializable()
class LitterSize {
  final int min;
  final int max;
  final int average;

  const LitterSize({
    required this.min,
    required this.max,
    required this.average,
  });

  factory LitterSize.fromJson(Map<String, dynamic> json) =>
      _$LitterSizeFromJson(json);
  Map<String, dynamic> toJson() => _$LitterSizeToJson(this);
}

@JsonSerializable()
class GestationPeriod {
  final int min;
  final int max;
  final int average;

  const GestationPeriod({
    required this.min,
    required this.max,
    required this.average,
  });

  factory GestationPeriod.fromJson(Map<String, dynamic> json) =>
      _$GestationPeriodFromJson(json);
  Map<String, dynamic> toJson() => _$GestationPeriodToJson(this);
}

@JsonSerializable()
class ReproductiveMaturity {
  @JsonKey(name: 'male_months')
  final int maleMonths;
  @JsonKey(name: 'female_months')
  final int femaleMonths;

  const ReproductiveMaturity({
    required this.maleMonths,
    required this.femaleMonths,
  });

  factory ReproductiveMaturity.fromJson(Map<String, dynamic> json) =>
      _$ReproductiveMaturityFromJson(json);
  Map<String, dynamic> toJson() => _$ReproductiveMaturityToJson(this);
}

@JsonSerializable()
class LifeSpan {
  final int min;
  final int max;
  final int average;

  const LifeSpan({
    required this.min,
    required this.max,
    required this.average,
  });

  factory LifeSpan.fromJson(Map<String, dynamic> json) =>
      _$LifeSpanFromJson(json);
  Map<String, dynamic> toJson() => _$LifeSpanToJson(this);
}

@JsonSerializable()
class WeightRange {
  final String male;
  final String female;

  const WeightRange({
    required this.male,
    required this.female,
  });

  factory WeightRange.fromJson(Map<String, dynamic> json) =>
      _$WeightRangeFromJson(json);
  Map<String, dynamic> toJson() => _$WeightRangeToJson(this);
}

@JsonSerializable()
class BreedStandardLink {
  final String organization;
  final String url;

  const BreedStandardLink({
    required this.organization,
    required this.url,
  });

  factory BreedStandardLink.fromJson(Map<String, dynamic> json) =>
      _$BreedStandardLinkFromJson(json);
  Map<String, dynamic> toJson() => _$BreedStandardLinkToJson(this);
}

@JsonSerializable()
class BreedImage {
  final String url;
  final String caption;
  @JsonKey(name: 'image_type')
  final String? imageType;

  const BreedImage({
    required this.url,
    required this.caption,
    this.imageType,
  });

  factory BreedImage.fromJson(Map<String, dynamic> json) =>
      _$BreedImageFromJson(json);
  Map<String, dynamic> toJson() => _$BreedImageToJson(this);
}

@JsonSerializable()
class BreedVideo {
  final String url;
  final String caption;

  const BreedVideo({
    required this.url,
    required this.caption,
  });

  factory BreedVideo.fromJson(Map<String, dynamic> json) =>
      _$BreedVideoFromJson(json);
  Map<String, dynamic> toJson() => _$BreedVideoToJson(this);
}

@JsonSerializable()
class AdoptionResource {
  final String name;
  final String url;

  const AdoptionResource({
    required this.name,
    required this.url,
  });

  factory AdoptionResource.fromJson(Map<String, dynamic> json) =>
      _$AdoptionResourceFromJson(json);
  Map<String, dynamic> toJson() => _$AdoptionResourceToJson(this);
} 