import 'package:json_annotation/json_annotation.dart';

part 'simple_cat_breed.g.dart';

@JsonSerializable()
class SimpleCatBreed {
  final String id;
  final String name;
  final List<String> aliases;
  final String origin;
  @JsonKey(name: 'breed_group')
  final String breedGroup;
  final String history;
  @JsonKey(name: 'fun_facts')
  final List<String> funFacts;
  @JsonKey(name: 'related_breeds')
  final List<String> relatedBreeds;
  final String status;
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;
  
  // Simplified fields
  final String? temperamentSummary;
  final String? appearanceDescription;
  final String? careInstructions;
  final String? healthInfo;
  final String? imageUrl;
  final String? coatLength;
  final String? size;
  final String? lifespan;

  const SimpleCatBreed({
    required this.id,
    required this.name,
    required this.aliases,
    required this.origin,
    required this.breedGroup,
    required this.history,
    required this.funFacts,
    required this.relatedBreeds,
    required this.status,
    required this.lastUpdated,
    this.temperamentSummary,
    this.appearanceDescription,
    this.careInstructions,
    this.healthInfo,
    this.imageUrl,
    this.coatLength,
    this.size,
    this.lifespan,
  });

  factory SimpleCatBreed.fromJson(Map<String, dynamic> json) => _$SimpleCatBreedFromJson(json);
  Map<String, dynamic> toJson() => _$SimpleCatBreedToJson(this);
}
