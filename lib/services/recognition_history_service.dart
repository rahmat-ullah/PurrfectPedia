import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../models/saved_breed.dart';
import '../models/cat_recognition_result.dart';
import 'database_service.dart';

// Helper function to convert various types to int (for SQLite compatibility)
int _intFromJson(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

class RecognitionHistoryService {
  static const String _savedBreedsTable = 'saved_breeds';
  static const String _recognitionHistoryTable = 'recognition_history';
  static const String _userStatsTable = 'user_stats';
  static const String _dailyQuotesTable = 'daily_quotes';

  final DatabaseService _databaseService = DatabaseService();

  // Initialize tables if they don't exist
  Future<void> initializeTables() async {
    final db = await _databaseService.database;
    
    // Create saved breeds table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_savedBreedsTable (
        id TEXT PRIMARY KEY,
        breed_id TEXT NOT NULL,
        breed_name TEXT NOT NULL,
        confidence REAL NOT NULL,
        image_url TEXT,
        saved_date INTEGER NOT NULL,
        recognition_id TEXT NOT NULL,
        notes TEXT
      )
    ''');

    // Create recognition history table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_recognitionHistoryTable (
        id TEXT PRIMARY KEY,
        image_url TEXT NOT NULL,
        recognition_date INTEGER NOT NULL,
        was_successful INTEGER NOT NULL,
        breeds_detected INTEGER NOT NULL,
        highest_confidence REAL,
        top_breed_name TEXT,
        notes TEXT
      )
    ''');

    // Create user stats table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_userStatsTable (
        user_id TEXT PRIMARY KEY,
        total_recognitions INTEGER NOT NULL DEFAULT 0,
        successful_recognitions INTEGER NOT NULL DEFAULT 0,
        breeds_discovered INTEGER NOT NULL DEFAULT 0,
        saved_breeds INTEGER NOT NULL DEFAULT 0,
        favorite_breeds INTEGER NOT NULL DEFAULT 0,
        last_recognition_date INTEGER,
        member_since INTEGER NOT NULL
      )
    ''');

    // Create daily quotes table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_dailyQuotesTable (
        id TEXT PRIMARY KEY,
        quote TEXT NOT NULL,
        author TEXT,
        category TEXT NOT NULL,
        date INTEGER NOT NULL,
        is_educational INTEGER NOT NULL
      )
    ''');
  }

  // Save a breed from recognition result
  Future<void> saveBreed({
    required String breedId,
    required String breedName,
    required double confidence,
    required String recognitionId,
    String? imageUrl,
    String? notes,
  }) async {
    final db = await _databaseService.database;
    
    final savedBreed = SavedBreed(
      id: 'saved_${DateTime.now().millisecondsSinceEpoch}',
      breedId: breedId,
      breedName: breedName,
      confidence: confidence,
      imageUrl: imageUrl,
      savedDate: DateTime.now(),
      recognitionId: recognitionId,
      notes: notes,
    );

    await db.insert(
      _savedBreedsTable,
      savedBreed.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Update user stats
    await _updateUserStats();
  }

  // Get all saved breeds
  Future<List<SavedBreed>> getSavedBreeds({int? limit}) async {
    final db = await _databaseService.database;
    
    final result = await db.query(
      _savedBreedsTable,
      orderBy: 'saved_date DESC',
      limit: limit,
    );

    return result.map((row) => SavedBreed.fromJson(row)).toList();
  }

  // Add recognition to history
  Future<void> addRecognitionHistory(CatRecognitionResult result) async {
    final db = await _databaseService.database;
    
    final history = RecognitionHistory(
      id: result.id,
      imageUrl: result.imageUrl,
      recognitionDate: result.date,
      wasSuccessful: result.predictions.isNotEmpty,
      breedsDetected: result.predictions.length,
      highestConfidence: result.predictions.isNotEmpty 
          ? result.predictions.map((p) => p.confidence).reduce((a, b) => a > b ? a : b)
          : null,
      topBreedName: result.predictions.isNotEmpty 
          ? result.predictions.first.breedName
          : null,
      notes: result.userNote,
    );

    await db.insert(
      _recognitionHistoryTable,
      history.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Update user stats
    await _updateUserStats();
  }

  // Get recognition history
  Future<List<RecognitionHistory>> getRecognitionHistory({int? limit}) async {
    final db = await _databaseService.database;
    
    final result = await db.query(
      _recognitionHistoryTable,
      orderBy: 'recognition_date DESC',
      limit: limit,
    );

    return result.map((row) => RecognitionHistory.fromJson(row)).toList();
  }

  // Get user statistics
  Future<UserStats> getUserStats() async {
    final db = await _databaseService.database;
    
    final result = await db.query(_userStatsTable, limit: 1);
    
    if (result.isEmpty) {
      // Create initial stats
      final initialStats = UserStats(
        totalRecognitions: 0,
        successfulRecognitions: 0,
        breedsDiscovered: 0,
        savedBreeds: 0,
        favoriteBreeds: 0,
        memberSince: DateTime.now(),
      );
      
      await db.insert(_userStatsTable, {
        'user_id': 'default_user',
        ...initialStats.toJson(),
      });
      
      return initialStats;
    }
    
    return UserStats.fromJson(result.first);
  }

  // Update user statistics
  Future<void> _updateUserStats() async {
    final db = await _databaseService.database;
    
    // Count totals from actual data
    final recognitionCount = await db.rawQuery('SELECT COUNT(*) as count FROM $_recognitionHistoryTable');
    final successfulCount = await db.rawQuery('SELECT COUNT(*) as count FROM $_recognitionHistoryTable WHERE was_successful = 1');
    final savedBreedsCount = await db.rawQuery('SELECT COUNT(*) as count FROM $_savedBreedsTable');
    final uniqueBreedsCount = await db.rawQuery('SELECT COUNT(DISTINCT breed_id) as count FROM $_savedBreedsTable');
    
    final totalRecognitions = _intFromJson(recognitionCount.first['count']);
    final successfulRecognitions = _intFromJson(successfulCount.first['count']);
    final savedBreeds = _intFromJson(savedBreedsCount.first['count']);
    final breedsDiscovered = _intFromJson(uniqueBreedsCount.first['count']);
    
    // Get last recognition date
    final lastRecognitionResult = await db.query(
      _recognitionHistoryTable,
      orderBy: 'recognition_date DESC',
      limit: 1,
    );
    
    DateTime? lastRecognitionDate;
    if (lastRecognitionResult.isNotEmpty) {
      lastRecognitionDate = DateTime.fromMillisecondsSinceEpoch(
        _intFromJson(lastRecognitionResult.first['recognition_date'])
      );
    }

    await db.insert(
      _userStatsTable,
      {
        'user_id': 'default_user',
        'total_recognitions': totalRecognitions,
        'successful_recognitions': successfulRecognitions,
        'breeds_discovered': breedsDiscovered,
        'saved_breeds': savedBreeds,
        'favorite_breeds': 0, // TODO: Implement favorites counting
        'last_recognition_date': lastRecognitionDate?.millisecondsSinceEpoch,
        'member_since': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get daily quote
  Future<DailyCatQuote?> getDailyQuote() async {
    final db = await _databaseService.database;
    
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    final result = await db.query(
      _dailyQuotesTable,
      where: 'date >= ? AND date < ?',
      whereArgs: [todayStart.millisecondsSinceEpoch, todayEnd.millisecondsSinceEpoch],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      return DailyCatQuote.fromJson(result.first);
    }
    
    // If no quote for today, create one
    return await _createDailyQuote();
  }

  // Create a daily quote
  Future<DailyCatQuote> _createDailyQuote() async {
    final db = await _databaseService.database;
    
    final quotes = [
      "Cats are connoisseurs of comfort. - James Herriot",
      "Time spent with cats is never wasted. - Sigmund Freud",
      "A cat has absolute emotional honesty. - Ernest Hemingway",
      "Cats choose us; we don't own them. - Kristin Cast",
      "In ancient times cats were worshipped as gods; they have not forgotten this. - Terry Pratchett",
      "A cat's eyes are windows enabling us to see into another world. - Irish Legend",
      "Cats are intended to teach us that not everything in nature has a function. - Garrison Keillor",
      "The smallest feline is a masterpiece. - Leonardo da Vinci",
    ];
    
    final today = DateTime.now();
    final quoteIndex = today.day % quotes.length;
    
    final quote = DailyCatQuote(
      id: 'daily_${today.year}_${today.month}_${today.day}',
      quote: quotes[quoteIndex],
      author: quotes[quoteIndex].split(' - ').length > 1 
          ? quotes[quoteIndex].split(' - ').last 
          : null,
      category: 'inspiration',
      date: today,
      isEducational: false,
    );
    
    await db.insert(
      _dailyQuotesTable,
      quote.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return quote;
  }

  // Delete saved breed
  Future<void> deleteSavedBreed(String id) async {
    final db = await _databaseService.database;
    await db.delete(_savedBreedsTable, where: 'id = ?', whereArgs: [id]);
    await _updateUserStats();
  }

  // Check if breed is saved
  Future<bool> isBreedSaved(String breedId, String recognitionId) async {
    final db = await _databaseService.database;
    final result = await db.query(
      _savedBreedsTable,
      where: 'breed_id = ? AND recognition_id = ?',
      whereArgs: [breedId, recognitionId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
