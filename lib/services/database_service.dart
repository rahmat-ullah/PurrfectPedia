import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cat_breed.dart';
import '../models/cat_fact.dart';
import '../models/cat_recognition_result.dart';
import '../models/user_profile.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'purrfect_pedia.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _breedsTable = 'breeds';
  static const String _factsTable = 'facts';
  static const String _recognitionResultsTable = 'recognition_results';
  static const String _userProfileTable = 'user_profile';
  static const String _favoritesTable = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create breeds table
    await db.execute('''
      CREATE TABLE $_breedsTable (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        last_updated INTEGER NOT NULL
      )
    ''');

    // Create facts table
    await db.execute('''
      CREATE TABLE $_factsTable (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        category TEXT NOT NULL,
        date_added INTEGER NOT NULL
      )
    ''');

    // Create recognition results table
    await db.execute('''
      CREATE TABLE $_recognitionResultsTable (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        date INTEGER NOT NULL
      )
    ''');

    // Create user profile table
    await db.execute('''
      CREATE TABLE $_userProfileTable (
        user_id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        last_updated INTEGER NOT NULL
      )
    ''');

    // Create favorites table
    await db.execute('''
      CREATE TABLE $_favoritesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        item_id TEXT NOT NULL,
        item_type TEXT NOT NULL,
        date_added INTEGER NOT NULL,
        UNIQUE(user_id, item_id, item_type)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  // Breed operations
  Future<void> insertBreed(CatBreed breed) async {
    final db = await database;
    await db.insert(
      _breedsTable,
      {
        'id': breed.id,
        'data': jsonEncode(breed.toJson()),
        'last_updated': breed.lastUpdated.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBreeds(List<CatBreed> breeds) async {
    final db = await database;
    final batch = db.batch();
    
    for (final breed in breeds) {
      batch.insert(
        _breedsTable,
        {
          'id': breed.id,
          'data': jsonEncode(breed.toJson()),
          'last_updated': breed.lastUpdated.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
  }

  Future<CatBreed?> getBreedById(String id) async {
    final db = await database;
    final result = await db.query(
      _breedsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    final data = jsonDecode(result.first['data'] as String);
    return CatBreed.fromJson(data);
  }

  Future<List<CatBreed>> getAllBreeds() async {
    final db = await database;
    final result = await db.query(_breedsTable);

    return result.map((row) {
      final data = jsonDecode(row['data'] as String);
      return CatBreed.fromJson(data);
    }).toList();
  }

  Future<List<CatBreed>> searchBreeds(String query) async {
    final db = await database;
    final result = await db.query(
      _breedsTable,
      where: 'data LIKE ?',
      whereArgs: ['%$query%'],
    );

    return result.map((row) {
      final data = jsonDecode(row['data'] as String);
      return CatBreed.fromJson(data);
    }).toList();
  }

  // Fact operations
  Future<void> insertFact(CatFact fact) async {
    final db = await database;
    await db.insert(
      _factsTable,
      {
        'id': fact.id,
        'data': jsonEncode(fact.toJson()),
        'category': fact.category,
        'date_added': fact.dateAdded.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CatFact>> getAllFacts() async {
    final db = await database;
    final result = await db.query(_factsTable, orderBy: 'date_added DESC');

    return result.map((row) {
      final data = jsonDecode(row['data'] as String);
      return CatFact.fromJson(data);
    }).toList();
  }

  Future<List<CatFact>> getFactsByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      _factsTable,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date_added DESC',
    );

    return result.map((row) {
      final data = jsonDecode(row['data'] as String);
      return CatFact.fromJson(data);
    }).toList();
  }

  // Recognition result operations
  Future<void> insertRecognitionResult(CatRecognitionResult result) async {
    final db = await database;
    await db.insert(
      _recognitionResultsTable,
      {
        'id': result.id,
        'data': jsonEncode(result.toJson()),
        'date': result.date.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CatRecognitionResult>> getAllRecognitionResults() async {
    final db = await database;
    final result = await db.query(_recognitionResultsTable, orderBy: 'date DESC');

    return result.map((row) {
      final data = jsonDecode(row['data'] as String);
      return CatRecognitionResult.fromJson(data);
    }).toList();
  }

  // User profile operations
  Future<void> insertOrUpdateUserProfile(UserProfile profile) async {
    final db = await database;
    await db.insert(
      _userProfileTable,
      {
        'user_id': profile.userId,
        'data': jsonEncode(profile.toJson()),
        'last_updated': profile.lastUpdated.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    final db = await database;
    final result = await db.query(
      _userProfileTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (result.isEmpty) return null;

    final data = jsonDecode(result.first['data'] as String);
    return UserProfile.fromJson(data);
  }

  // Favorites operations
  Future<void> addToFavorites(String userId, String itemId, String itemType) async {
    final db = await database;
    await db.insert(
      _favoritesTable,
      {
        'user_id': userId,
        'item_id': itemId,
        'item_type': itemType,
        'date_added': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeFromFavorites(String userId, String itemId, String itemType) async {
    final db = await database;
    await db.delete(
      _favoritesTable,
      where: 'user_id = ? AND item_id = ? AND item_type = ?',
      whereArgs: [userId, itemId, itemType],
    );
  }

  Future<bool> isFavorite(String userId, String itemId, String itemType) async {
    final db = await database;
    final result = await db.query(
      _favoritesTable,
      where: 'user_id = ? AND item_id = ? AND item_type = ?',
      whereArgs: [userId, itemId, itemType],
    );

    return result.isNotEmpty;
  }

  Future<List<String>> getFavoriteIds(String userId, String itemType) async {
    final db = await database;
    final result = await db.query(
      _favoritesTable,
      columns: ['item_id'],
      where: 'user_id = ? AND item_type = ?',
      whereArgs: [userId, itemType],
      orderBy: 'date_added DESC',
    );

    return result.map((row) => row['item_id'] as String).toList();
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(_breedsTable);
    await db.delete(_factsTable);
    await db.delete(_recognitionResultsTable);
    await db.delete(_userProfileTable);
    await db.delete(_favoritesTable);
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
} 