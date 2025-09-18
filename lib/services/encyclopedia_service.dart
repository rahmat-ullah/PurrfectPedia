import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/cat_breed.dart';
import 'database_service.dart';
import 'breed_database_populator.dart';

class EncyclopediaService {
  final DatabaseService _databaseService = DatabaseService();
  final BreedDatabasePopulator _populator = BreedDatabasePopulator();
  
  static const String _breedsDataPath = 'assets/data/breeds_data_structure.json';

  /// Initializes the encyclopedia database with comprehensive breed data
  Future<void> initializeEncyclopedia() async {
    try {
      print('Initializing Encyclopedia database...');
      
      // Check if database is already populated
      final existingBreeds = await _databaseService.getAllBreeds();
      if (existingBreeds.isNotEmpty) {
        print('Encyclopedia already initialized with ${existingBreeds.length} breeds.');
        return;
      }

      // Populate database with comprehensive breed data
      await _populator.populateDatabase();
      
      print('Encyclopedia initialization completed successfully!');
    } catch (e) {
      print('Error initializing encyclopedia: $e');
      rethrow;
    }
  }

  /// Gets all breeds from the database
  Future<List<CatBreed>> getAllBreeds() async {
    try {
      return await _databaseService.getAllBreeds();
    } catch (e) {
      print('Error getting all breeds: $e');
      return [];
    }
  }

  /// Gets a specific breed by ID
  Future<CatBreed?> getBreedById(String breedId) async {
    try {
      return await _databaseService.getBreedById(breedId);
    } catch (e) {
      print('Error getting breed by ID: $e');
      return null;
    }
  }

  /// Searches breeds by name or alias
  Future<List<CatBreed>> searchBreeds(String query) async {
    try {
      final allBreeds = await getAllBreeds();
      final lowercaseQuery = query.toLowerCase();
      
      return allBreeds.where((breed) {
        // Search in name
        if (breed.name.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
        
        // Search in aliases
        for (final alias in breed.aliases) {
          if (alias.toLowerCase().contains(lowercaseQuery)) {
            return true;
          }
        }
        
        // Search in origin
        if (breed.origin.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
        
        // Search in breed group
        if (breed.breedGroup.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
        
        return false;
      }).toList();
    } catch (e) {
      print('Error searching breeds: $e');
      return [];
    }
  }

  /// Gets breeds by origin country
  Future<List<CatBreed>> getBreedsByOrigin(String origin) async {
    try {
      final allBreeds = await getAllBreeds();
      return allBreeds.where((breed) => 
        breed.origin.toLowerCase().contains(origin.toLowerCase())
      ).toList();
    } catch (e) {
      print('Error getting breeds by origin: $e');
      return [];
    }
  }

  /// Gets breeds by breed group
  Future<List<CatBreed>> getBreedsByGroup(String breedGroup) async {
    try {
      final allBreeds = await getAllBreeds();
      return allBreeds.where((breed) => 
        breed.breedGroup.toLowerCase() == breedGroup.toLowerCase()
      ).toList();
    } catch (e) {
      print('Error getting breeds by group: $e');
      return [];
    }
  }

  /// Gets random breeds for featured content
  Future<List<CatBreed>> getRandomBreeds(int count) async {
    try {
      final allBreeds = await getAllBreeds();
      allBreeds.shuffle();
      return allBreeds.take(count).toList();
    } catch (e) {
      print('Error getting random breeds: $e');
      return [];
    }
  }

  /// Gets popular breeds (based on predefined list)
  Future<List<CatBreed>> getPopularBreeds() async {
    try {
      final popularBreedIds = [
        'maine_coon',
        'persian',
        'siamese',
        'bengal',
        'ragdoll',
        'british_shorthair',
        'abyssinian',
        'russian_blue',
        'sphynx',
        'norwegian_forest'
      ];
      
      final breeds = <CatBreed>[];
      for (final id in popularBreedIds) {
        final breed = await getBreedById(id);
        if (breed != null) {
          breeds.add(breed);
        }
      }
      
      return breeds;
    } catch (e) {
      print('Error getting popular breeds: $e');
      return [];
    }
  }

  /// Gets breed statistics
  Future<Map<String, dynamic>> getBreedStatistics() async {
    try {
      final allBreeds = await getAllBreeds();
      
      // Count by origin
      final originCounts = <String, int>{};
      for (final breed in allBreeds) {
        originCounts[breed.origin] = (originCounts[breed.origin] ?? 0) + 1;
      }
      
      // Count by breed group
      final groupCounts = <String, int>{};
      for (final breed in allBreeds) {
        groupCounts[breed.breedGroup] = (groupCounts[breed.breedGroup] ?? 0) + 1;
      }
      
      return {
        'totalBreeds': allBreeds.length,
        'originCounts': originCounts,
        'groupCounts': groupCounts,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('Error getting breed statistics: $e');
      return {};
    }
  }

  /// Forces a refresh of the encyclopedia data
  Future<void> refreshEncyclopedia() async {
    try {
      print('Refreshing Encyclopedia database...');
      
      // Clear existing data
      // Note: This would require implementing a clear method in DatabaseService
      
      // Repopulate with fresh data
      await _populator.populateDatabase();
      
      print('Encyclopedia refresh completed successfully!');
    } catch (e) {
      print('Error refreshing encyclopedia: $e');
      rethrow;
    }
  }

  /// Loads breed data structure template from assets
  Future<Map<String, dynamic>?> loadBreedDataStructure() async {
    try {
      final String jsonString = await rootBundle.loadString(_breedsDataPath);
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error loading breed data structure: $e');
      return null;
    }
  }

  /// Validates breed data completeness
  Future<Map<String, dynamic>> validateBreedData() async {
    try {
      final allBreeds = await getAllBreeds();
      final issues = <String>[];
      final warnings = <String>[];
      
      for (final breed in allBreeds) {
        // Check for missing required fields
        if (breed.name.isEmpty) {
          issues.add('Breed ${breed.id}: Missing name');
        }
        if (breed.origin.isEmpty) {
          issues.add('Breed ${breed.id}: Missing origin');
        }
        if (breed.history.isEmpty || breed.history == 'Detailed history information to be added.') {
          warnings.add('Breed ${breed.id}: Missing detailed history');
        }
        if (breed.temperamentSummary?.isEmpty == true || breed.temperamentSummary == 'Temperament details to be added.') {
          warnings.add('Breed ${breed.id}: Missing temperament details');
        }
        if (breed.appearanceDescription?.isEmpty == true || breed.appearanceDescription == 'Appearance details to be added.') {
          warnings.add('Breed ${breed.id}: Missing appearance details');
        }
        if (breed.careInstructions?.isEmpty == true || breed.careInstructions == 'Care instructions to be added.') {
          warnings.add('Breed ${breed.id}: Missing care instructions');
        }
        if (breed.healthInfo?.isEmpty == true || breed.healthInfo == 'Health information to be added.') {
          warnings.add('Breed ${breed.id}: Missing health information');
        }
        if (breed.funFacts.isEmpty || (breed.funFacts.length == 1 && breed.funFacts.first == 'Comprehensive breed information coming soon.')) {
          warnings.add('Breed ${breed.id}: Missing fun facts');
        }
      }
      
      return {
        'totalBreeds': allBreeds.length,
        'issues': issues,
        'warnings': warnings,
        'completionRate': warnings.isEmpty ? 100.0 : ((allBreeds.length - warnings.length) / allBreeds.length * 100),
        'validationDate': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('Error validating breed data: $e');
      return {'error': e.toString()};
    }
  }
}
