import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/breed.dart';

class BreedService {
  static List<Breed> _breeds = [];
  static bool _isLoaded = false;

  /// Load breed data from JSON file
  static Future<void> loadBreeds() async {
    if (_isLoaded) return;

    try {
      final String response = await rootBundle.loadString('assets/data/breeds_data_structure.json');
      final data = json.decode(response);
      
      // Handle both single breed object and list of breeds
      if (data is Map) {
        _breeds = [Breed.fromJson(Map<String, dynamic>.from(data))];
      } else if (data is List) {
        _breeds = data.map((json) => Breed.fromJson(Map<String, dynamic>.from(json))).toList();
      }
      
      _isLoaded = true;
    } catch (e) {
      print('Error loading breed data: $e');
      _breeds = [];
    }
  }

  /// Get all breeds
  static Future<List<Breed>> getAllBreeds() async {
    await loadBreeds();
    return _breeds;
  }

  /// Get breed by ID
  static Future<Breed?> getBreedById(String id) async {
    await loadBreeds();
    try {
      return _breeds.firstWhere((breed) => breed.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search breeds by name, origin, or traits
  static Future<List<Breed>> searchBreeds(String query) async {
    await loadBreeds();
    if (query.isEmpty) return _breeds;

    final lowercaseQuery = query.toLowerCase();
    return _breeds.where((breed) {
      return breed.name.toLowerCase().contains(lowercaseQuery) ||
             breed.origin.toLowerCase().contains(lowercaseQuery) ||
             breed.aliases.any((alias) => alias.toLowerCase().contains(lowercaseQuery)) ||
             breed.temperament.traits.any((trait) => trait.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  /// Filter breeds by cross breed status
  static Future<List<Breed>> getBreedsByType({bool? isCrossbreed}) async {
    await loadBreeds();
    if (isCrossbreed == null) return _breeds;
    return _breeds.where((breed) => breed.isCrossbreed == isCrossbreed).toList();
  }

  /// Filter breeds by origin
  static Future<List<Breed>> getBreedsByOrigin(String origin) async {
    await loadBreeds();
    return _breeds.where((breed) => 
      breed.origin.toLowerCase() == origin.toLowerCase()).toList();
  }

  /// Filter breeds by size
  static Future<List<Breed>> getBreedsBySize(String size) async {
    await loadBreeds();
    return _breeds.where((breed) => 
      breed.appearance.size.toLowerCase() == size.toLowerCase()).toList();
  }

  /// Filter breeds by coat length
  static Future<List<Breed>> getBreedsByCoatLength(String coatLength) async {
    await loadBreeds();
    return _breeds.where((breed) => 
      breed.appearance.coatLength.toLowerCase() == coatLength.toLowerCase()).toList();
  }

  /// Filter breeds by temperament trait
  static Future<List<Breed>> getBreedsByTemperament(String trait) async {
    await loadBreeds();
    return _breeds.where((breed) => 
      breed.temperament.traits.any((t) => t.toLowerCase() == trait.toLowerCase())).toList();
  }

  /// Get breeds good with children
  static Future<List<Breed>> getChildFriendlyBreeds() async {
    await loadBreeds();
    return _breeds.where((breed) => breed.temperament.socialWithKids).toList();
  }

  /// Get breeds good with dogs
  static Future<List<Breed>> getDogFriendlyBreeds() async {
    await loadBreeds();
    return _breeds.where((breed) => breed.temperament.socialWithDogs).toList();
  }

  /// Get breeds good with other cats
  static Future<List<Breed>> getCatFriendlyBreeds() async {
    await loadBreeds();
    return _breeds.where((breed) => breed.temperament.socialWithCats).toList();
  }

  /// Get related breeds
  static Future<List<Breed>> getRelatedBreeds(String breedId) async {
    await loadBreeds();
    final breed = await getBreedById(breedId);
    if (breed == null) return [];

    final relatedIds = breed.relatedBreeds;
    final related = <Breed>[];
    
    for (final id in relatedIds) {
      final relatedBreed = await getBreedById(id.toLowerCase().replaceAll(' ', '_'));
      if (relatedBreed != null) {
        related.add(relatedBreed);
      }
    }
    
    return related;
  }

  /// Get parent breeds for cross breeds
  static Future<List<Breed>> getParentBreeds(String crossbreedId) async {
    await loadBreeds();
    final breed = await getBreedById(crossbreedId);
    if (breed?.crossbreedInfo == null) return [];

    final parentIds = breed!.crossbreedInfo!.parentBreedIds;
    final parents = <Breed>[];
    
    for (final id in parentIds) {
      final parentBreed = await getBreedById(id);
      if (parentBreed != null) {
        parents.add(parentBreed);
      }
    }
    
    return parents;
  }

  /// Get unique origins
  static Future<List<String>> getUniqueOrigins() async {
    await loadBreeds();
    return _breeds.map((breed) => breed.origin).toSet().toList()..sort();
  }

  /// Get unique sizes
  static Future<List<String>> getUniqueSizes() async {
    await loadBreeds();
    return _breeds.map((breed) => breed.appearance.size).toSet().toList()..sort();
  }

  /// Get unique coat lengths
  static Future<List<String>> getUniqueCoatLengths() async {
    await loadBreeds();
    return _breeds.map((breed) => breed.appearance.coatLength).toSet().toList()..sort();
  }

  /// Get unique temperament traits
  static Future<List<String>> getUniqueTemperamentTraits() async {
    await loadBreeds();
    final traits = <String>{};
    for (final breed in _breeds) {
      traits.addAll(breed.temperament.traits);
    }
    return traits.toList()..sort();
  }

  /// Get breed statistics
  static Future<Map<String, dynamic>> getBreedStatistics() async {
    await loadBreeds();
    final crossbreeds = _breeds.where((breed) => breed.isCrossbreed).length;
    final purebreds = _breeds.length - crossbreeds;
    
    return {
      'total': _breeds.length,
      'crossbreeds': crossbreeds,
      'purebreds': purebreds,
      'origins': (await getUniqueOrigins()).length,
      'sizes': (await getUniqueSizes()).length,
      'coat_lengths': (await getUniqueCoatLengths()).length,
    };
  }

  /// Advanced filter method
  static Future<List<Breed>> filterBreeds({
    String? origin,
    String? size,
    String? coatLength,
    List<String>? temperamentTraits,
    bool? isCrossbreed,
    bool? goodWithKids,
    bool? goodWithDogs,
    bool? goodWithCats,
    String? activityLevel,
    String? intelligence,
  }) async {
    await loadBreeds();
    
    return _breeds.where((breed) {
      // Origin filter
      if (origin != null && breed.origin.toLowerCase() != origin.toLowerCase()) {
        return false;
      }
      
      // Size filter
      if (size != null && breed.appearance.size.toLowerCase() != size.toLowerCase()) {
        return false;
      }
      
      // Coat length filter
      if (coatLength != null && 
          breed.appearance.coatLength.toLowerCase() != coatLength.toLowerCase()) {
        return false;
      }
      
      // Temperament traits filter
      if (temperamentTraits != null && temperamentTraits.isNotEmpty) {
        final hasRequiredTraits = temperamentTraits.every((trait) =>
          breed.temperament.traits.any((breedTrait) => 
            breedTrait.toLowerCase() == trait.toLowerCase()));
        if (!hasRequiredTraits) return false;
      }
      
      // Cross breed filter
      if (isCrossbreed != null && breed.isCrossbreed != isCrossbreed) {
        return false;
      }
      
      // Social compatibility filters
      if (goodWithKids != null && breed.temperament.socialWithKids != goodWithKids) {
        return false;
      }
      
      if (goodWithDogs != null && breed.temperament.socialWithDogs != goodWithDogs) {
        return false;
      }
      
      if (goodWithCats != null && breed.temperament.socialWithCats != goodWithCats) {
        return false;
      }
      
      // Activity level filter
      if (activityLevel != null && 
          breed.temperament.activityLevel.toLowerCase() != activityLevel.toLowerCase()) {
        return false;
      }
      
      // Intelligence filter
      if (intelligence != null && 
          breed.temperament.intelligence.toLowerCase() != intelligence.toLowerCase()) {
        return false;
      }
      
      return true;
    }).toList();
  }

  /// Clear cached data (useful for testing or forced reload)
  static void clearCache() {
    _breeds.clear();
    _isLoaded = false;
  }
} 