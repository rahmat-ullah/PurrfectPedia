import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat_breed.dart';
import '../services/api_service.dart';
import '../widgets/breed_card.dart';
import '../widgets/search_bar_widget.dart';
import 'breed_detail_screen.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  final ApiService _apiService = ApiService();
  List<CatBreed> _breeds = [];
  List<CatBreed> _filteredBreeds = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Natural',
    'Hybrid',
    'Mutation',
    'Large',
    'Medium',
    'Small',
  ];

  @override
  void initState() {
    super.initState();
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // For now, create mock data since we don't have real API integration
      _breeds = _createMockBreeds();
      _filteredBreeds = _breeds;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading breeds: $e')),
        );
      }
    }
  }

  List<CatBreed> _createMockBreeds() {
    return [
      CatBreed(
        id: 'maine_coon',
        name: 'Maine Coon',
        aliases: ['Coon Cat', 'Maine Shag'],
        origin: 'United States',
        breedGroup: 'Natural',
        recognition: [
          const BreedRecognition(organization: 'TICA', status: 'recognized'),
          const BreedRecognition(organization: 'CFA', status: 'recognized'),
        ],
        history: 'The Maine Coon originated in the US state of Maine...',
        appearance: const Appearance(
          bodyType: 'Large, muscular, rectangular',
          weightRange: '5.9–8.2 kg (13–18 lbs)',
          averageHeight: '25–41 cm',
          coatLength: 'Long',
          coatColors: ['Brown Tabby', 'Black', 'White', 'Various'],
          eyeColors: ['Green', 'Gold', 'Copper'],
          distinctiveFeatures: ['Tufted ears', 'Bushy tail', 'Large paws'],
        ),
        temperament: const Temperament(
          summary: 'Gentle, playful, intelligent, and social',
          activityLevel: 'Medium',
          vocalizationLevel: 'Moderate',
          affectionLevel: 'High',
          intelligence: 'High',
          socialWithKids: true,
          socialWithDogs: true,
          socialWithCats: true,
          trainability: 'High',
        ),
        care: const Care(
          groomingNeeds: 'Moderate (weekly brushing)',
          shedding: 'Moderate',
          exerciseNeeds: 'Moderate (daily play recommended)',
          dietaryNotes: 'No special dietary needs',
        ),
        health: const Health(
          lifespan: '12–15 years',
          commonIssues: ['Hypertrophic Cardiomyopathy', 'Hip Dysplasia'],
          geneticTests: ['HCM DNA Test', 'SMA DNA Test'],
          veterinaryRecommendations: 'Annual health check-ups',
        ),
        breedStandardLinks: [],
        funFacts: [
          'The Maine Coon is one of the largest domesticated cat breeds.',
          'Known as "gentle giants" due to their size and friendly nature.',
        ],
        images: [
          const MediaItem(url: 'https://example.com/maine-coon1.jpg', caption: 'Classic Maine Coon'),
        ],
        videos: [],
        adoptionResources: [],
        relatedBreeds: ['Norwegian Forest Cat', 'Siberian'],
        status: 'Extant',
        lastUpdated: DateTime.now(),
      ),
      // Add more mock breeds here...
    ];
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterBreeds();
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filterBreeds();
    });
  }

  void _filterBreeds() {
    _filteredBreeds = _breeds.where((breed) {
      final matchesSearch = _searchQuery.isEmpty ||
          breed.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          breed.origin.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter = _selectedFilter == 'All' ||
          breed.breedGroup.toLowerCase() == _selectedFilter.toLowerCase() ||
          (_selectedFilter == 'Large' && breed.appearance.weightRange.contains('8')) ||
          (_selectedFilter == 'Medium' && breed.appearance.weightRange.contains('5')) ||
          (_selectedFilter == 'Small' && breed.appearance.weightRange.contains('3'));

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get theme data

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Encyclopedia'),
        // backgroundColor: theme.primaryColor, // Already set by theme
        // foregroundColor: Colors.white, // Already set by theme
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceVariant, // Updated background
            child: Column(
              children: [
                SearchBarWidget(
                  onSearchChanged: _onSearchChanged,
                  hintText: 'Search breeds...',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filterOptions.length,
                    itemBuilder: (context, index) {
                      final filter = _filterOptions[index];
                      final isSelected = filter == _selectedFilter;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected 
                                  ? theme.colorScheme.onPrimaryContainer 
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) => _onFilterChanged(filter),
                          backgroundColor: theme.chipTheme.backgroundColor ?? theme.colorScheme.surface,
                          selectedColor: theme.chipTheme.selectedColor ?? theme.colorScheme.primaryContainer,
                          // Ensure checkmark color is appropriate if default is not visible
                          checkmarkColor: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Breeds List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary)))
                : _filteredBreeds.isEmpty
                    ? Center(
                        child: Text(
                          'No breeds found',
                          style: TextStyle(
                            fontSize: 18, 
                            color: theme.colorScheme.onBackground.withOpacity(0.6), // Updated text color
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadBreeds,
                        color: theme.colorScheme.primary, // Refresh indicator color
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredBreeds.length,
                          itemBuilder: (context, index) {
                            final breed = _filteredBreeds[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: BreedCard(
                                breed: breed,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BreedDetailScreen(breed: breed),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
} 