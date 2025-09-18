import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cat_breed.dart';
import '../models/cat_fact.dart';
import '../models/cat_recognition_result.dart';
import '../models/user_profile.dart';
import '../models/saved_breed.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'purrfect_pedia.db';
  static const int _databaseVersion = 3;

  // Table names
  static const String _breedsTable = 'breeds';
  static const String _factsTable = 'facts';
  static const String _recognitionResultsTable = 'recognition_results';
  static const String _userProfileTable = 'user_profile';
  static const String _favoritesTable = 'favorites';
  static const String _savedBreedsTable = 'saved_breeds';
  static const String _recognitionHistoryTable = 'recognition_history';

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

    // Create saved breeds table
    await db.execute('''
      CREATE TABLE $_savedBreedsTable (
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
      CREATE TABLE $_recognitionHistoryTable (
        id TEXT PRIMARY KEY,
        image_url TEXT NOT NULL,
        recognition_date INTEGER NOT NULL,
        was_successful INTEGER NOT NULL,
        breeds_detected INTEGER NOT NULL DEFAULT 0,
        highest_confidence REAL,
        top_breed_name TEXT,
        result_data TEXT,
        notes TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add notes column to recognition_history table
      try {
        await db.execute('ALTER TABLE $_recognitionHistoryTable ADD COLUMN notes TEXT');
        print('Successfully added notes column to recognition_history table');
      } catch (e) {
        print('Error adding notes column (may already exist): $e');
        // Column might already exist, continue
      }
    }

    if (oldVersion < 3) {
      // Add missing columns to saved_breeds table
      try {
        await db.execute('ALTER TABLE $_savedBreedsTable ADD COLUMN breed_id TEXT');
        print('Successfully added breed_id column to saved_breeds table');
      } catch (e) {
        print('Error adding breed_id column (may already exist): $e');
      }

      try {
        await db.execute('ALTER TABLE $_savedBreedsTable ADD COLUMN recognition_id TEXT');
        print('Successfully added recognition_id column to saved_breeds table');
      } catch (e) {
        print('Error adding recognition_id column (may already exist): $e');
      }

      try {
        await db.execute('ALTER TABLE $_savedBreedsTable ADD COLUMN notes TEXT');
        print('Successfully added notes column to saved_breeds table');
      } catch (e) {
        print('Error adding notes column to saved_breeds table (may already exist): $e');
      }
    }
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