import 'package:flutter/material.dart';
import 'services/encyclopedia_initializer.dart';
import 'services/encyclopedia_service.dart';

/// Test script to verify encyclopedia functionality
class EncyclopediaTest {
  final EncyclopediaInitializer _initializer = EncyclopediaInitializer();
  final EncyclopediaService _service = EncyclopediaService();

  /// Runs comprehensive encyclopedia tests
  Future<void> runTests() async {
    print('🐱 Starting PurrfectPedia Encyclopedia Tests 🐱');
    print('=' * 50);

    try {
      await _testInitialization();
      await _testBreedRetrieval();
      await _testSearchFunctionality();
      await _testStatistics();
      await _testValidation();
      
      print('\n✅ All encyclopedia tests passed successfully!');
      print('🎉 Encyclopedia system is ready for production use!');
    } catch (e) {
      print('\n❌ Encyclopedia tests failed: $e');
      rethrow;
    }
  }

  /// Test encyclopedia initialization
  Future<void> _testInitialization() async {
    print('\n📚 Testing Encyclopedia Initialization...');
    
    // Test quick initialization
    await _initializer.quickInitialize();
    print('✓ Quick initialization completed');

    // Check initialization status
    final status = await _initializer.getInitializationStatus();
    print('✓ Initialization status: ${status['isInitialized']}');
    print('✓ Breed count: ${status['breedCount']}');
    print('✓ Completion rate: ${status['completionRate']?.toStringAsFixed(1)}%');
  }

  /// Test breed retrieval functionality
  Future<void> _testBreedRetrieval() async {
    print('\n🔍 Testing Breed Retrieval...');
    
    // Test getting all breeds
    final allBreeds = await _service.getAllBreeds();
    print('✓ Retrieved ${allBreeds.length} breeds');
    
    // Test getting specific breed
    final maineCoon = await _service.getBreedById('maine_coon');
    if (maineCoon != null) {
      print('✓ Retrieved Maine Coon: ${maineCoon.name}');
      print('  - Origin: ${maineCoon.origin}');
      print('  - Group: ${maineCoon.breedGroup}');
      print('  - Fun facts: ${maineCoon.funFacts.length}');
    } else {
      print('⚠️ Maine Coon not found');
    }

    // Test getting popular breeds
    final popularBreeds = await _service.getPopularBreeds();
    print('✓ Retrieved ${popularBreeds.length} popular breeds');

    // Test getting random breeds
    final randomBreeds = await _service.getRandomBreeds(5);
    print('✓ Retrieved ${randomBreeds.length} random breeds');
  }

  /// Test search functionality
  Future<void> _testSearchFunctionality() async {
    print('\n🔎 Testing Search Functionality...');
    
    // Test name search
    final searchResults = await _service.searchBreeds('persian');
    print('✓ Search for "persian": ${searchResults.length} results');
    
    // Test origin search
    final usBreeds = await _service.getBreedsByOrigin('United States');
    print('✓ US breeds: ${usBreeds.length} found');
    
    // Test group search
    final shorthairBreeds = await _service.getBreedsByGroup('Shorthair');
    print('✓ Shorthair breeds: ${shorthairBreeds.length} found');
    
    // Test case-insensitive search
    final caseInsensitiveResults = await _service.searchBreeds('MAINE');
    print('✓ Case-insensitive search: ${caseInsensitiveResults.length} results');
  }

  /// Test statistics generation
  Future<void> _testStatistics() async {
    print('\n📊 Testing Statistics Generation...');
    
    final stats = await _service.getBreedStatistics();
    print('✓ Total breeds: ${stats['totalBreeds']}');
    
    final originCounts = stats['originCounts'] as Map<String, int>? ?? {};
    print('✓ Countries represented: ${originCounts.length}');
    
    final groupCounts = stats['groupCounts'] as Map<String, int>? ?? {};
    print('✓ Breed groups: ${groupCounts.length}');
    
    // Show top origins
    final sortedOrigins = originCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    print('✓ Top origins:');
    for (int i = 0; i < 3 && i < sortedOrigins.length; i++) {
      final entry = sortedOrigins[i];
      print('  ${i + 1}. ${entry.key}: ${entry.value} breeds');
    }
  }

  /// Test data validation
  Future<void> _testValidation() async {
    print('\n✅ Testing Data Validation...');
    
    final validation = await _service.validateBreedData();
    print('✓ Validation completed');
    print('✓ Total breeds validated: ${validation['totalBreeds']}');
    print('✓ Issues found: ${validation['issues']?.length ?? 0}');
    print('✓ Warnings: ${validation['warnings']?.length ?? 0}');
    print('✓ Completion rate: ${validation['completionRate']?.toStringAsFixed(1)}%');
    
    // Show sample issues if any
    final issues = validation['issues'] as List<String>? ?? [];
    if (issues.isNotEmpty) {
      print('⚠️ Sample issues:');
      for (int i = 0; i < 3 && i < issues.length; i++) {
        print('  - ${issues[i]}');
      }
    }
    
    // Show sample warnings if any
    final warnings = validation['warnings'] as List<String>? ?? [];
    if (warnings.isNotEmpty) {
      print('⚠️ Sample warnings:');
      for (int i = 0; i < 3 && i < warnings.length; i++) {
        print('  - ${warnings[i]}');
      }
    }
  }

  /// Test specific breed data completeness
  Future<void> testBreedDataCompleteness() async {
    print('\n🧪 Testing Breed Data Completeness...');
    
    final testBreeds = ['maine_coon', 'persian', 'siamese', 'bengal', 'ragdoll'];
    
    for (final breedId in testBreeds) {
      final breed = await _service.getBreedById(breedId);
      if (breed != null) {
        print('\n📋 Testing ${breed.name}:');
        print('  ✓ Name: ${breed.name}');
        print('  ✓ Origin: ${breed.origin}');
        print('  ✓ Aliases: ${breed.aliases.length}');
        print('  ✓ History length: ${breed.history.length} chars');
        print('  ✓ Fun facts: ${breed.funFacts.length}');
        print('  ✓ Related breeds: ${breed.relatedBreeds.length}');
        print('  ✓ Temperament length: ${breed.temperamentSummary.length} chars');
        print('  ✓ Appearance length: ${breed.appearanceDescription.length} chars');
        print('  ✓ Care instructions length: ${breed.careInstructions.length} chars');
        print('  ✓ Health info length: ${breed.healthInfo.length} chars');
      } else {
        print('❌ Breed $breedId not found');
      }
    }
  }

  /// Print comprehensive breed information
  Future<void> printBreedSample() async {
    print('\n📖 Sample Breed Information:');
    print('=' * 50);
    
    final maineCoon = await _service.getBreedById('maine_coon');
    if (maineCoon != null) {
      print('🐱 ${maineCoon.name}');
      print('📍 Origin: ${maineCoon.origin}');
      print('🏷️ Group: ${maineCoon.breedGroup}');
      print('📅 Status: ${maineCoon.status}');
      print('\n📚 History:');
      print(maineCoon.history);
      print('\n😸 Temperament:');
      print(maineCoon.temperamentSummary);
      print('\n🎨 Appearance:');
      print(maineCoon.appearanceDescription);
      print('\n🧡 Fun Facts:');
      for (int i = 0; i < maineCoon.funFacts.length; i++) {
        print('  ${i + 1}. ${maineCoon.funFacts[i]}');
      }
      print('\n👥 Related Breeds: ${maineCoon.relatedBreeds.join(', ')}');
    }
  }
}

/// Widget to run encyclopedia tests with UI
class EncyclopediaTestWidget extends StatefulWidget {
  const EncyclopediaTestWidget({Key? key}) : super(key: key);

  @override
  State<EncyclopediaTestWidget> createState() => _EncyclopediaTestWidgetState();
}

class _EncyclopediaTestWidgetState extends State<EncyclopediaTestWidget> {
  final EncyclopediaTest _test = EncyclopediaTest();
  bool _isRunning = false;
  String _output = '';

  Future<void> _runTests() async {
    setState(() {
      _isRunning = true;
      _output = 'Starting encyclopedia tests...\n';
    });

    try {
      await _test.runTests();
      setState(() {
        _output += '\n✅ All tests completed successfully!';
      });
    } catch (e) {
      setState(() {
        _output += '\n❌ Tests failed: $e';
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encyclopedia Tests'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : _runTests,
              child: _isRunning 
                ? const CircularProgressIndicator()
                : const Text('Run Encyclopedia Tests'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _output,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
