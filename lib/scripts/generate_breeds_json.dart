import 'dart:io';
import '../services/json_breed_populator.dart';

/// Script to generate comprehensive breeds JSON file
void main() async {
  print('Generating comprehensive breeds JSON file...');
  
  try {
    // Generate the comprehensive breeds data
    final breedsData = JsonBreedPopulator.generateAllBreedsData();
    
    // Save to the assets directory
    await JsonBreedPopulator.saveToJsonFile('assets/data/breeds_data_structure.json');
    
    print('✅ Successfully generated ${breedsData.length} breeds in JSON file!');
    print('📁 File saved to: assets/data/breeds_data_structure.json');
    
    // Print summary
    print('\n📊 Breed Summary:');
    print('Total breeds: ${breedsData.length}');
    
    final origins = breedsData.map((breed) => breed['origin']).toSet();
    print('Origins: ${origins.length} (${origins.join(', ')})');
    
    final breedGroups = breedsData.map((breed) => breed['breed_group']).toSet();
    print('Breed groups: ${breedGroups.length} (${breedGroups.join(', ')})');
    
    final crossbreeds = breedsData.where((breed) => breed['is_crossbreed'] == true).length;
    print('Crossbreeds: $crossbreeds');
    print('Purebreds: ${breedsData.length - crossbreeds}');
    
  } catch (e) {
    print('❌ Error generating breeds JSON: $e');
    exit(1);
  }
}
