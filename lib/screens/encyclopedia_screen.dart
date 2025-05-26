import 'package:flutter/material.dart';
import '../models/cat_breed.dart'; // Ensure this refers to the new model
import '../services/api_service.dart';
import './breed_detail_screen.dart'; // Ensure this uses the new CatBreed model

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  final ApiService _apiService = ApiService();
  List<CatBreed> _breeds = []; // New CatBreed model
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final breeds = await _apiService.fetchCatBreeds(); // Uses new API method
      setState(() {
        _breeds = breeds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load breeds: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Breeds (Ninja)'), // Updated title
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBreeds,
          ),
        ],
      ),
      body: _buildBody(), // Similar to _buildBody in BreedsListScreen
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadBreeds,
              child: const Text('Retry'),
            )
          ],
        ),
      );
    }
    if (_breeds.isEmpty) {
      return const Center(child: Text('No cat breeds found.'));
    }
    return ListView.builder(
      itemCount: _breeds.length,
      itemBuilder: (context, index) {
        final breed = _breeds[index];
        return ListTile(
          title: Text(breed.breed),
          subtitle: Text(breed.country.isNotEmpty ? breed.country : 'Country not specified'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BreedDetailScreen(breed: breed),
              ),
            );
          },
        );
      },
    );
  }
}