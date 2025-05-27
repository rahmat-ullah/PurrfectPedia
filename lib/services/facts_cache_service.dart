import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cat_fact.dart';

class FactsCacheService {
  static const String _dailyFactKey = 'daily_fact';
  static const String _dailyFactDateKey = 'daily_fact_date';
  static const String _factsListKey = 'facts_list';
  static const String _factsListDateKey = 'facts_list_date';
  static const String _favoritesKey = 'favorite_facts';
  static const String _randomFactKey = 'random_fact';
  static const String _randomFactDateKey = 'random_fact_date';

  // Cache daily fact for 24 hours
  Future<void> cacheDailyFact(CatFact fact) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dailyFactKey, jsonEncode({
      'id': fact.id,
      'factText': fact.factText,
      'category': fact.category,
      'dateAdded': fact.dateAdded.toIso8601String(),
    }));
    await prefs.setString(_dailyFactDateKey, DateTime.now().toIso8601String());
  }

  Future<CatFact?> getCachedDailyFact() async {
    final prefs = await SharedPreferences.getInstance();
    final factJson = prefs.getString(_dailyFactKey);
    final dateString = prefs.getString(_dailyFactDateKey);
    
    if (factJson == null || dateString == null) return null;
    
    final cacheDate = DateTime.parse(dateString);
    final now = DateTime.now();
    
    // Check if cached fact is still valid (within 24 hours)
    if (now.difference(cacheDate).inHours >= 24) {
      return null;
    }
    
    final factData = jsonDecode(factJson);
    return CatFact(
      id: factData['id'],
      factText: factData['factText'],
      category: factData['category'],
      dateAdded: DateTime.parse(factData['dateAdded']),
    );
  }

  // Cache random fact for 1 hour
  Future<void> cacheRandomFact(CatFact fact) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_randomFactKey, jsonEncode({
      'id': fact.id,
      'factText': fact.factText,
      'category': fact.category,
      'dateAdded': fact.dateAdded.toIso8601String(),
    }));
    await prefs.setString(_randomFactDateKey, DateTime.now().toIso8601String());
  }

  Future<CatFact?> getCachedRandomFact() async {
    final prefs = await SharedPreferences.getInstance();
    final factJson = prefs.getString(_randomFactKey);
    final dateString = prefs.getString(_randomFactDateKey);
    
    if (factJson == null || dateString == null) return null;
    
    final cacheDate = DateTime.parse(dateString);
    final now = DateTime.now();
    
    // Check if cached fact is still valid (within 1 hour)
    if (now.difference(cacheDate).inHours >= 1) {
      return null;
    }
    
    final factData = jsonDecode(factJson);
    return CatFact(
      id: factData['id'],
      factText: factData['factText'],
      category: factData['category'],
      dateAdded: DateTime.parse(factData['dateAdded']),
    );
  }

  // Cache facts list for 2 days
  Future<void> cacheFactsList(List<CatFact> facts, int currentPage, int lastPage, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final factsJson = facts.map((fact) => {
      'id': fact.id,
      'factText': fact.factText,
      'category': fact.category,
      'dateAdded': fact.dateAdded.toIso8601String(),
    }).toList();
    
    await prefs.setString(_factsListKey, jsonEncode({
      'facts': factsJson,
      'currentPage': currentPage,
      'lastPage': lastPage,
      'total': total,
    }));
    await prefs.setString(_factsListDateKey, DateTime.now().toIso8601String());
  }

  Future<Map<String, dynamic>?> getCachedFactsList() async {
    final prefs = await SharedPreferences.getInstance();
    final factsJson = prefs.getString(_factsListKey);
    final dateString = prefs.getString(_factsListDateKey);
    
    if (factsJson == null || dateString == null) return null;
    
    final cacheDate = DateTime.parse(dateString);
    final now = DateTime.now();
    
    // Check if cached facts are still valid (within 2 days)
    if (now.difference(cacheDate).inDays >= 2) {
      return null;
    }
    
    final data = jsonDecode(factsJson);
    final List<dynamic> factsData = data['facts'];
    
    final facts = factsData.map((factData) => CatFact(
      id: factData['id'],
      factText: factData['factText'],
      category: factData['category'],
      dateAdded: DateTime.parse(factData['dateAdded']),
    )).toList();
    
    return {
      'facts': facts,
      'currentPage': data['currentPage'],
      'lastPage': data['lastPage'],
      'total': data['total'],
    };
  }

  // Favorites management
  Future<void> addToFavorites(CatFact fact) async {
    final favorites = await getFavorites();
    if (!favorites.any((f) => f.factText == fact.factText)) {
      favorites.add(fact);
      await _saveFavorites(favorites);
    }
  }

  Future<void> removeFromFavorites(CatFact fact) async {
    final favorites = await getFavorites();
    favorites.removeWhere((f) => f.factText == fact.factText);
    await _saveFavorites(favorites);
  }

  Future<bool> isFavorite(CatFact fact) async {
    final favorites = await getFavorites();
    return favorites.any((f) => f.factText == fact.factText);
  }

  Future<List<CatFact>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson == null) return [];
    
    final List<dynamic> favoritesData = jsonDecode(favoritesJson);
    return favoritesData.map((factData) => CatFact(
      id: factData['id'],
      factText: factData['factText'],
      category: factData['category'],
      dateAdded: DateTime.parse(factData['dateAdded']),
    )).toList();
  }

  Future<void> _saveFavorites(List<CatFact> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = favorites.map((fact) => {
      'id': fact.id,
      'factText': fact.factText,
      'category': fact.category,
      'dateAdded': fact.dateAdded.toIso8601String(),
    }).toList();
    
    await prefs.setString(_favoritesKey, jsonEncode(favoritesJson));
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailyFactKey);
    await prefs.remove(_dailyFactDateKey);
    await prefs.remove(_factsListKey);
    await prefs.remove(_factsListDateKey);
    await prefs.remove(_randomFactKey);
    await prefs.remove(_randomFactDateKey);
  }
}