// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:purrfect_pedia/models/simple_cat_breed.dart';
import 'package:purrfect_pedia/models/cat_fact.dart';

void main() {
  group('JSON Serialization Tests', () {
    test('SimpleCatBreed JSON serialization works', () {
      final breed = SimpleCatBreed(
        id: 'test_breed',
        name: 'Test Breed',
        aliases: ['Test Cat'],
        origin: 'Test Country',
        breedGroup: 'Test Group',
        history: 'Test history',
        funFacts: ['Test fact'],
        relatedBreeds: ['Related breed'],
        status: 'Active',
        lastUpdated: DateTime.now(),
      );

      // Test toJson
      final json = breed.toJson();
      expect(json['id'], equals('test_breed'));
      expect(json['name'], equals('Test Breed'));

      // Test fromJson
      final breedFromJson = SimpleCatBreed.fromJson(json);
      expect(breedFromJson.id, equals(breed.id));
      expect(breedFromJson.name, equals(breed.name));
    });

    test('CatFact JSON serialization works', () {
      final fact = CatFact(
        id: 'test_fact',
        factText: 'Test fact text',
        category: 'Test',
        dateAdded: DateTime.now(),
      );

      // Test toJson
      final json = fact.toJson();
      expect(json['id'], equals('test_fact'));
      expect(json['factText'], equals('Test fact text'));

      // Test fromJson
      final factFromJson = CatFact.fromJson(json);
      expect(factFromJson.id, equals(fact.id));
      expect(factFromJson.factText, equals(fact.factText));
    });
  });
}
