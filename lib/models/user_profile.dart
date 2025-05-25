// import 'package:json_annotation/json_annotation.dart';

// part 'user_profile.g.dart';

// @JsonSerializable()
class UserProfile {
  // @JsonKey(name: 'user_id')
  final String userId;
  // @JsonKey(name: 'display_name')
  final String? displayName;
  // @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  // @JsonKey(name: 'favorite_breed_ids')
  final List<String> favoriteBreedIds;
  // @JsonKey(name: 'favorite_fact_ids')
  final List<String> favoriteFactIds;
  // @JsonKey(name: 'recognition_history_ids')
  final List<String> recognitionHistoryIds;
  // @JsonKey(name: 'preferred_language')
  final String preferredLanguage;
  final String theme;
  // @JsonKey(name: 'created_at')
  final DateTime createdAt;
  // @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;

  const UserProfile({
    required this.userId,
    this.displayName,
    this.avatarUrl,
    required this.favoriteBreedIds,
    required this.favoriteFactIds,
    required this.recognitionHistoryIds,
    required this.preferredLanguage,
    required this.theme,
    required this.createdAt,
    required this.lastUpdated,
  });

  // factory UserProfile.fromJson(Map<String, dynamic> json) => 
  //     _$UserProfileFromJson(json);
  // Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? userId,
    String? displayName,
    String? avatarUrl,
    List<String>? favoriteBreedIds,
    List<String>? favoriteFactIds,
    List<String>? recognitionHistoryIds,
    String? preferredLanguage,
    String? theme,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      favoriteBreedIds: favoriteBreedIds ?? this.favoriteBreedIds,
      favoriteFactIds: favoriteFactIds ?? this.favoriteFactIds,
      recognitionHistoryIds: recognitionHistoryIds ?? this.recognitionHistoryIds,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
} 