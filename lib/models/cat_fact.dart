// import 'package:json_annotation/json_annotation.dart';

// part 'cat_fact.g.dart';

// @JsonSerializable()
class CatFact {
  final String fact;
  final int length;

  const CatFact({
    required this.fact,
    required this.length,
  });

  // Add a fromJson factory method for parsing
  factory CatFact.fromJson(Map<String, dynamic> json) {
    return CatFact(
      fact: json['fact'] as String,
      length: json['length'] as int,
    );
  }

  // Add a toJson method (optional, but good practice)
  // Map<String, dynamic> toJson() => _$CatFactToJson(this); // If using build_runner
   Map<String, dynamic> toJson() { // Manual implementation
    return {
      'fact': fact,
      'length': length,
    };
  }
}