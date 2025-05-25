// import 'package:json_annotation/json_annotation.dart';

// part 'cat_fact.g.dart';

// @JsonSerializable()
class CatFact {
  final String id;
  // @JsonKey(name: 'fact_text')
  final String factText;
  final String category;
  // @JsonKey(name: 'source_url')
  final String? sourceUrl;
  // @JsonKey(name: 'date_added')
  final DateTime dateAdded;

  const CatFact({
    required this.id,
    required this.factText,
    required this.category,
    this.sourceUrl,
    required this.dateAdded,
  });

  // factory CatFact.fromJson(Map<String, dynamic> json) => _$CatFactFromJson(json);
  // Map<String, dynamic> toJson() => _$CatFactToJson(this);
}

// @JsonSerializable()
class CatQuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  // @JsonKey(name: 'correct_option_index')
  final int correctOptionIndex;
  final String explanation;
  final String? category;

  const CatQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.category,
  });

  // factory CatQuizQuestion.fromJson(Map<String, dynamic> json) => 
  //     _$CatQuizQuestionFromJson(json);
  // Map<String, dynamic> toJson() => _$CatQuizQuestionToJson(this);
} 