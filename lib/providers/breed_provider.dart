import 'package:flutter/foundation.dart';
import '../models/simple_cat_breed.dart';
import '../services/api_service.dart';

enum LoadingState { idle, loading, success, error }

class BreedProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<SimpleCatBreed> _breeds = [];
  List<SimpleCatBreed> _filteredBreeds = [];
  List<String> _favoriteBreedIds = [];
  LoadingState _loadingState = LoadingState.idle;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  // Getters
  List<SimpleCatBreed> get breeds => _breeds;
  List<SimpleCatBreed> get filteredBreeds => _filteredBreeds;
  List<String> get favoriteBreedIds => _favoriteBreedIds;
  LoadingState get loadingState => _loadingState;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _loadingState == LoadingState.loading;
  bool get hasError => _loadingState == LoadingState.error;

  // Load all breeds
  Future<void> loadBreeds() async {
    if (_loadingState == LoadingState.loading) return;

    _setLoadingState(LoadingState.loading);

    final result = await _apiService.fetchBreeds();

    result.when(
      success: (breeds) {
        _breeds = breeds;
        _filteredBreeds = breeds;
        _setLoadingState(LoadingState.success);
      },
      onError: (error) {
        _errorMessage = error.message;
        _setLoadingState(LoadingState.error);
      },
      loading: () {
        // This shouldn't happen in this context
      },
    );
  }

  // Search breeds
  void searchBreeds(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Apply filter
  void applyFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  // Apply filters and search
  void _applyFilters() {
    List<SimpleCatBreed> filtered = _breeds;

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((breed) {
        return breed.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               breed.origin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               breed.aliases.any((alias) => 
                 alias.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Apply category filter
    switch (_selectedFilter) {
      case 'All':
        // No additional filtering
        break;
      case 'Favorites':
        filtered = filtered.where((breed) => 
          _favoriteBreedIds.contains(breed.id)).toList();
        break;
      case 'Large':
        filtered = filtered.where((breed) => 
          breed.size?.toLowerCase() == 'large').toList();
        break;
      case 'Medium':
        filtered = filtered.where((breed) => 
          breed.size?.toLowerCase() == 'medium').toList();
        break;
      case 'Small':
        filtered = filtered.where((breed) => 
          breed.size?.toLowerCase() == 'small').toList();
        break;
      case 'Long Hair':
        filtered = filtered.where((breed) => 
          breed.coatLength?.toLowerCase().contains('long') == true).toList();
        break;
      case 'Short Hair':
        filtered = filtered.where((breed) => 
          breed.coatLength?.toLowerCase().contains('short') == true).toList();
        break;
    }

    _filteredBreeds = filtered;
  }

  // Toggle favorite
  void toggleFavorite(String breedId) {
    if (_favoriteBreedIds.contains(breedId)) {
      _favoriteBreedIds.remove(breedId);
    } else {
      _favoriteBreedIds.add(breedId);
    }
    
    // Refresh filtered breeds if showing favorites
    if (_selectedFilter == 'Favorites') {
      _applyFilters();
    }
    
    notifyListeners();
  }

  // Check if breed is favorite
  bool isFavorite(String breedId) {
    return _favoriteBreedIds.contains(breedId);
  }

  // Get breed by ID
  SimpleCatBreed? getBreedById(String id) {
    try {
      return _breeds.firstWhere((breed) => breed.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_loadingState == LoadingState.error) {
      _setLoadingState(LoadingState.idle);
    }
  }

  // Private helper to set loading state
  void _setLoadingState(LoadingState state) {
    _loadingState = state;
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await loadBreeds();
  }
}
