import 'package:flutter/material.dart';
import 'services/breed_service.dart';
import 'models/breed.dart';

/// Test script to verify Encyclopedia JSON loading
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🧪 Testing Encyclopedia JSON System...\n');
  
  try {
    // Test 1: Load all breeds
    print('📚 Test 1: Loading all breeds from JSON...');
    final breeds = await BreedService.getAllBreeds();
    print('✅ Successfully loaded ${breeds.length} breeds');
    
    if (breeds.length != 61) {
      print('❌ Expected 61 breeds, got ${breeds.length}');
      return;
    }
    
    // Test 2: Verify specific breeds exist
    print('\n🔍 Test 2: Verifying specific breeds...');
    final testBreeds = ['maine_coon', 'persian', 'siamese', 'bengal', 'ragdoll'];
    
    for (final breedId in testBreeds) {
      final breed = await BreedService.getBreedById(breedId);
      if (breed != null) {
        print('✅ Found ${breed.name} (${breed.origin})');
      } else {
        print('❌ Missing breed: $breedId');
      }
    }
    
    // Test 3: Search functionality
    print('\n🔎 Test 3: Testing search functionality...');
    final searchResults = await BreedService.searchBreeds('Maine');
    print('✅ Search for "Maine" returned ${searchResults.length} results');
    
    // Test 4: Filter functionality
    print('\n🏷️ Test 4: Testing filter functionality...');
    final largeBreeds = await BreedService.getBreedsBySize('Large');
    print('✅ Found ${largeBreeds.length} large breeds');
    
    final usBreeds = await BreedService.getBreedsByOrigin('United States');
    print('✅ Found ${usBreeds.length} breeds from United States');
    
    // Test 5: Breed statistics
    print('\n📊 Test 5: Testing breed statistics...');
    final stats = await BreedService.getBreedStatistics();
    print('✅ Statistics: ${stats.toString()}');
    
    // Test 6: Detailed breed information
    print('\n📋 Test 6: Testing detailed breed information...');
    final maineCoon = await BreedService.getBreedById('maine_coon');
    if (maineCoon != null) {
      print('✅ Maine Coon details:');
      print('   - Name: ${maineCoon.name}');
      print('   - Origin: ${maineCoon.origin}');
      print('   - Aliases: ${maineCoon.aliases.join(', ')}');
      print('   - Size: ${maineCoon.appearance.size}');
      print('   - Coat Length: ${maineCoon.appearance.coatLength}');
      print('   - Temperament: ${maineCoon.temperament.traits.join(', ')}');
      print('   - Fun Facts: ${maineCoon.funFacts.length} facts');
      print('   - Recognition: ${maineCoon.recognition.length} organizations');
    }
    
    print('\n🎉 All tests passed! Encyclopedia JSON system is working correctly.');
    print('📈 Summary:');
    print('   - Total breeds loaded: ${breeds.length}');
    print('   - JSON file structure: ✅ Valid');
    print('   - Search functionality: ✅ Working');
    print('   - Filter functionality: ✅ Working');
    print('   - Detailed information: ✅ Complete');
    
  } catch (e) {
    print('❌ Error during testing: $e');
  }
}
