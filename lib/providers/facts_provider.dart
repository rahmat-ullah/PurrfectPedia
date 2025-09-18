import 'package:flutter/foundation.dart';
import '../models/cat_fact.dart';
import '../services/api_service.dart';
import '../services/facts_cache_service.dart';

enum FactsLoadingState { idle, loading, success, error }

class FactsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FactsCacheService _cacheService = FactsCacheService();
  
  CatFact? _dailyFact;
  List<CatFact> _factsList = [];
  CatFact? _randomFact;
  List<String> _favoriteFactIds = [];
  
  FactsLoadingState _dailyFactState = FactsLoadingState.idle;
  FactsLoadingState _factsListState = FactsLoadingState.idle;
  FactsLoadingState _randomFactState = FactsLoadingState.idle;
  
  String? _errorMessage;
  int _currentPage = 1;
  int _lastPage = 1;
  bool _hasNextPage = false;

  // Getters
  CatFact? get dailyFact => _dailyFact;
  List<CatFact> get factsList => _factsList;
  CatFact? get randomFact => _randomFact;
  List<String> get favoriteFactIds => _favoriteFactIds;
  
  FactsLoadingState get dailyFactState => _dailyFactState;
  FactsLoadingState get factsListState => _factsListState;
  FactsLoadingState get randomFactState => _randomFactState;
  
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  
  bool get isDailyFactLoading => _dailyFactState == FactsLoadingState.loading;
  bool get isFactsListLoading => _factsListState == FactsLoadingState.loading;
  bool get isRandomFactLoading => _randomFactState == FactsLoadingState.loading;

  // Load daily fact
  Future<void> loadDailyFact() async {
    if (_dailyFactState == FactsLoadingState.loading) return;
    
    _setDailyFactState(FactsLoadingState.loading);
    
    try {
      // Try to get cached daily fact first
      _dailyFact = await _cacheService.getCachedDailyFact();
      
      if (_dailyFact == null) {
        // Fetch new daily fact
        final result = await _apiService.fetchRandomFact();

        result.when(
          success: (fact) async {
            _dailyFact = fact;
            await _cacheService.cacheDailyFact(fact);
          },
          onError: (error) {
            _errorMessage = error.message;
            _setDailyFactState(FactsLoadingState.error);
            return;
          },
          loading: () {
            // This shouldn't happen in this context
          },
        );
      }
      
      _setDailyFactState(FactsLoadingState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setDailyFactState(FactsLoadingState.error);
    }
  }

  // Load facts list
  Future<void> loadFactsList({bool isRefresh = false}) async {
    if (_factsListState == FactsLoadingState.loading) return;
    
    _setFactsListState(FactsLoadingState.loading);
    
    try {
      if (isRefresh) {
        _currentPage = 1;
        _factsList.clear();
      }

      // Try to get cached facts first (only for first page)
      if (_currentPage == 1 && !isRefresh) {
        final cachedData = await _cacheService.getCachedFactsList();
        if (cachedData != null) {
          _factsList = cachedData['facts'];
          _currentPage = cachedData['currentPage'];
          _lastPage = cachedData['lastPage'];
          _hasNextPage = _currentPage < _lastPage;
          _setFactsListState(FactsLoadingState.success);
          return;
        }
      }

      // Fetch facts from API
      final response = await _apiService.fetchFactsList(
        page: _currentPage,
        limit: 10,
      );
      
      final facts = response['facts'] as List<CatFact>;
      _currentPage = response['currentPage'];
      _lastPage = response['lastPage'];
      _hasNextPage = response['hasNextPage'];
      
      if (isRefresh) {
        _factsList = facts;
      } else {
        _factsList.addAll(facts);
      }
      
      // Cache the facts (only first page)
      if (_currentPage == 1) {
        await _cacheService.cacheFactsList(
          _factsList,
          _currentPage,
          _lastPage,
          response['total'],
        );
      }
      
      _setFactsListState(FactsLoadingState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setFactsListState(FactsLoadingState.error);
    }
  }

  // Load more facts (pagination)
  Future<void> loadMoreFacts() async {
    if (!_hasNextPage || _factsListState == FactsLoadingState.loading) return;
    
    _currentPage++;
    await loadFactsList();
  }

  // Load random fact
  Future<void> loadRandomFact() async {
    if (_randomFactState == FactsLoadingState.loading) return;
    
    _setRandomFactState(FactsLoadingState.loading);
    
    try {
      // Try to get cached random fact first
      _randomFact = await _cacheService.getCachedRandomFact();
      
      if (_randomFact == null) {
        // Fetch new random fact
        final result = await _apiService.fetchRandomFact();

        result.when(
          success: (fact) async {
            _randomFact = fact;
            await _cacheService.cacheRandomFact(fact);
          },
          onError: (error) {
            _errorMessage = error.message;
            _setRandomFactState(FactsLoadingState.error);
            return;
          },
          loading: () {
            // This shouldn't happen in this context
          },
        );
      }
      
      _setRandomFactState(FactsLoadingState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setRandomFactState(FactsLoadingState.error);
    }
  }

  // Toggle favorite fact
  void toggleFavorite(String factId) {
    if (_favoriteFactIds.contains(factId)) {
      _favoriteFactIds.remove(factId);
    } else {
      _favoriteFactIds.add(factId);
    }
    notifyListeners();
  }

  // Check if fact is favorite
  bool isFavorite(String factId) {
    return _favoriteFactIds.contains(factId);
  }

  // Get favorite facts
  List<CatFact> get favoriteFacts {
    return _factsList.where((fact) => 
      _favoriteFactIds.contains(fact.id)).toList();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Private helper methods
  void _setDailyFactState(FactsLoadingState state) {
    _dailyFactState = state;
    notifyListeners();
  }

  void _setFactsListState(FactsLoadingState state) {
    _factsListState = state;
    notifyListeners();
  }

  void _setRandomFactState(FactsLoadingState state) {
    _randomFactState = state;
    notifyListeners();
  }

  // Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadDailyFact(),
      loadFactsList(isRefresh: true),
      loadRandomFact(),
    ]);
  }
}
