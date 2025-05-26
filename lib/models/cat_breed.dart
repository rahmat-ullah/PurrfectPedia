// lib/models/cat_breed.dart

class CatBreed {
  final String breed;
  final String country;
  final String origin;
  final String coat;
  final String pattern;

  const CatBreed({
    required this.breed,
    required this.country,
    required this.origin,
    required this.coat,
    required this.pattern,
  });

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      breed: json['breed'] as String? ?? '', // Handle potential nulls with default
      country: json['country'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      coat: json['coat'] as String? ?? '',
      pattern: json['pattern'] as String? ?? '',
    );
  }

  // Optional: Add a toJson method for completeness, though not strictly needed for this step.
  Map<String, dynamic> toJson() {
    return {
      'breed': breed,
      'country': country,
      'origin': origin,
      'coat': coat,
      'pattern': pattern,
    };
  }
}