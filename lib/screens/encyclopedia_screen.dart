import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/breed.dart';
import '../services/breed_service.dart';
import '../widgets/breed_thumbnail_card.dart';
import '../widgets/search_bar_widget.dart';
import 'breed_detail_screen.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  List<Breed> _breeds = [];
  List<Breed> _filteredBreeds = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  List<String> _favoriteBreeds = [];

  final List<String> _filterOptions = [
    'All',
    'Purebred',
    'Cross Breed',
    'Large',
    'Medium',
    'Small',
    'Long Hair',
    'Short Hair',
    'Child Friendly',
    'Dog Friendly',
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

      final breeds = await BreedService.getAllBreeds();
      
      setState(() {
        _breeds = breeds;
        _filteredBreeds = breeds;
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

  Future<void> _filterBreeds() async {
    List<Breed> filtered = [];

    switch (_selectedFilter) {
      case 'All':
        filtered = await BreedService.searchBreeds(_searchQuery);
        break;
      case 'Purebred':
        filtered = await BreedService.filterBreeds(
          isCrossbreed: false,
        );
        break;
      case 'Cross Breed':
        filtered = await BreedService.filterBreeds(
          isCrossbreed: true,
        );
        break;
      case 'Large':
        filtered = await BreedService.getBreedsBySize('Large');
        break;
      case 'Medium':
        filtered = await BreedService.getBreedsBySize('Medium');
        break;
      case 'Small':
        filtered = await BreedService.getBreedsBySize('Small');
        break;
      case 'Long Hair':
        filtered = await BreedService.getBreedsByCoatLength('Long');
        break;
      case 'Short Hair':
        filtered = await BreedService.getBreedsByCoatLength('Short');
        break;
      case 'Child Friendly':
        filtered = await BreedService.getChildFriendlyBreeds();
        break;
      case 'Dog Friendly':
        filtered = await BreedService.getDogFriendlyBreeds();
        break;
      default:
        filtered = _breeds;
    }

    // Apply search query if any
    if (_searchQuery.isNotEmpty && _selectedFilter != 'All') {
      final lowercaseQuery = _searchQuery.toLowerCase();
      filtered = filtered.where((breed) {
        return breed.name.toLowerCase().contains(lowercaseQuery) ||
               breed.origin.toLowerCase().contains(lowercaseQuery) ||
               breed.aliases.any((alias) => alias.toLowerCase().contains(lowercaseQuery)) ||
               breed.temperament.traits.any((trait) => trait.toLowerCase().contains(lowercaseQuery));
      }).toList();
    }

    setState(() {
      _filteredBreeds = filtered;
    });
  }

  void _toggleFavorite(String breedId) {
    setState(() {
      if (_favoriteBreeds.contains(breedId)) {
        _favoriteBreeds.remove(breedId);
      } else {
        _favoriteBreeds.add(breedId);
      }
    });
  }

  void _navigateToBreedDetail(Breed breed) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreedDetailScreen(breed: breed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.pets,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(width: 8),
            const Text('PurrfectPedia'),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBreeds,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SearchBarWidget(
                  onSearchChanged: _onSearchChanged,
                  hintText: 'Search breeds, origins, or traits...',
                ),
                const SizedBox(height: 12),
                
                // Filter Chips
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
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            _onFilterChanged(filter);
                          },
                          backgroundColor: theme.colorScheme.surface,
                          selectedColor: theme.colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: isSelected 
                                ? theme.colorScheme.onPrimaryContainer 
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Breed count
                const SizedBox(height: 8),
                Text(
                  '${_filteredBreeds.length} breeds found',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Breeds Grid
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredBreeds.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No breeds found',
                              style: TextStyle(
                                fontSize: 18,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : MasonryGridView.count(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredBreeds.length,
                        itemBuilder: (context, index) {
                          final breed = _filteredBreeds[index];
                          return BreedThumbnailCard(
                            breed: breed,
                            isFavorite: _favoriteBreeds.contains(breed.id),
                            onTap: () => _navigateToBreedDetail(breed),
                            onFavoriteToggle: () => _toggleFavorite(breed.id),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
} 