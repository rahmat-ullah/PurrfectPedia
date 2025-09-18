import 'package:flutter/material.dart';
import '../models/cat_fact.dart';
import '../services/api_service.dart';
import '../services/facts_cache_service.dart';
import '../widgets/fact_card.dart';

class FactsScreen extends StatefulWidget {
  const FactsScreen({super.key});

  @override
  State<FactsScreen> createState() => _FactsScreenState();
}

class _FactsScreenState extends State<FactsScreen> with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final FactsCacheService _cacheService = FactsCacheService();
  
  late TabController _tabController;
  
  // Daily Fact Tab
  CatFact? _dailyFact;
  bool _isDailyFactLoading = true;
  
  // Browse Facts Tab
  List<CatFact> _factsList = [];
  bool _isFactsListLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;
  int _totalFacts = 0;
  
  // Random Fact Tab
  CatFact? _randomFact;
  bool _isRandomFactLoading = false;
  
  // Favorites Tab
  List<CatFact> _favorites = [];
  bool _isFavoritesLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadDailyFact(),
      _loadFactsList(),
      _loadFavorites(),
    ]);
  }

  Future<void> _loadDailyFact() async {
    setState(() {
      _isDailyFactLoading = true;
    });

    try {
      // Try to get cached daily fact first
      CatFact? cachedFact = await _cacheService.getCachedDailyFact();
      
      if (cachedFact != null) {
        setState(() {
          _dailyFact = cachedFact;
          _isDailyFactLoading = false;
        });
        return;
      }

      // If no cached fact or expired, fetch new one
      final result = await _apiService.fetchRandomFact();

      result.when(
        success: (fact) async {
          await _cacheService.cacheDailyFact(fact);
          setState(() {
            _dailyFact = fact;
            _isDailyFactLoading = false;
          });
        },
        onError: (error) {
          setState(() {
            _isDailyFactLoading = false;
          });
          // Show error to user
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load daily fact: ${error.message}')),
            );
          }
        },
        loading: () {
          // This shouldn't happen in this context
        },
      );
    } catch (e) {
      setState(() {
        _isDailyFactLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading daily fact: $e')),
        );
      }
    }
  }

  Future<void> _loadFactsList({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _isFactsListLoading = true;
        _currentPage = 1;
        _factsList.clear();
      });
    } else {
      setState(() {
        _isFactsListLoading = true;
      });
    }

    try {
      // Try to get cached facts list first (only for first page)
      if (_currentPage == 1) {
        final cachedData = await _cacheService.getCachedFactsList();
        
        if (cachedData != null) {
          setState(() {
            _factsList = cachedData['facts'];
            _currentPage = cachedData['currentPage'];
            _lastPage = cachedData['lastPage'];
            _totalFacts = cachedData['total'];
            _isFactsListLoading = false;
          });
          return;
        }
      }

      // Fetch from API
      final result = await _apiService.fetchFactsList(page: _currentPage);
      final facts = result['facts'] as List<CatFact>;
      
      // Cache only the first page
      if (_currentPage == 1) {
        await _cacheService.cacheFactsList(
          facts,
          result['currentPage'],
          result['lastPage'],
          result['total'],
        );
      }
      
      setState(() {
        if (isRefresh || _currentPage == 1) {
          _factsList = facts;
        } else {
          _factsList.addAll(facts);
        }
        _currentPage = result['currentPage'];
        _lastPage = result['lastPage'];
        _totalFacts = result['total'];
        _isFactsListLoading = false;
      });
    } catch (e) {
      setState(() {
        _isFactsListLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading facts: $e')),
        );
      }
    }
  }

  Future<void> _loadMoreFacts() async {
    if (_isLoadingMore || _currentPage >= _lastPage) return;
    
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    try {
      final result = await _apiService.fetchFactsList(page: _currentPage);
      final facts = result['facts'] as List<CatFact>;
      
      setState(() {
        _factsList.addAll(facts);
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _currentPage--; // Revert page increment on error
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading more facts: $e')),
        );
      }
    }
  }

  Future<void> _loadRandomFact() async {
    setState(() {
      _isRandomFactLoading = true;
    });

    try {
      // Try to get cached random fact first
      CatFact? cachedFact = await _cacheService.getCachedRandomFact();
      
      if (cachedFact != null) {
        setState(() {
          _randomFact = cachedFact;
          _isRandomFactLoading = false;
        });
        return;
      }

      // Fetch new random fact
      final result = await _apiService.fetchRandomFact();

      result.when(
        success: (fact) async {
          await _cacheService.cacheRandomFact(fact);
          setState(() {
            _randomFact = fact;
            _isRandomFactLoading = false;
          });
        },
        onError: (error) {
          setState(() {
            _isRandomFactLoading = false;
          });
          // Show error to user
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load random fact: ${error.message}')),
            );
          }
        },
        loading: () {
          // This shouldn't happen in this context
        },
      );
    } catch (e) {
      setState(() {
        _isRandomFactLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading random fact: $e')),
        );
      }
    }
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isFavoritesLoading = true;
    });

    try {
      final favorites = await _cacheService.getFavorites();
      setState(() {
        _favorites = favorites;
        _isFavoritesLoading = false;
      });
    } catch (e) {
      setState(() {
        _isFavoritesLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(CatFact fact) async {
    try {
      final isFav = await _cacheService.isFavorite(fact);
      
      if (isFav) {
        await _cacheService.removeFromFavorites(fact);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        await _cacheService.addToFavorites(fact);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }
      
      // Refresh favorites list if we're on that tab
      if (_tabController.index == 3) {
        await _loadFavorites();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorites: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Fact Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              switch (_tabController.index) {
                case 0:
                  _loadDailyFact();
                  break;
                case 1:
                  _loadFactsList(isRefresh: true);
                  break;
                case 2:
                  _loadRandomFact();
                  break;
                case 3:
                  _loadFavorites();
                  break;
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.today), text: 'Daily'),
            Tab(icon: Icon(Icons.list), text: 'Browse'),
            Tab(icon: Icon(Icons.shuffle), text: 'Random'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyFactTab(),
          _buildBrowseFactsTab(),
          _buildRandomFactTab(),
          _buildFavoritesTab(),
        ],
      ),
    );
  }

  Widget _buildDailyFactTab() {
    if (_isDailyFactLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_dailyFact == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No daily fact available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDailyFact,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Fact of the Day',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _dailyFact!.factText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FutureBuilder<bool>(
                        future: _cacheService.isFavorite(_dailyFact!),
                        builder: (context, snapshot) {
                          final isFavorite = snapshot.data ?? false;
                          return IconButton.filled(
                            onPressed: () => _toggleFavorite(_dailyFact!),
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                            ),
                          );
                        },
                      ),
                      IconButton.filled(
                        onPressed: () {
                          // TODO: Implement share functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sharing fact...')),
                          );
                        },
                        icon: const Icon(Icons.share),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseFactsTab() {
    if (_isFactsListLoading && _factsList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_factsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No facts available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadFactsList(isRefresh: true),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadFactsList(isRefresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _factsList.length + (_currentPage < _lastPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _factsList.length) {
            // Load more button
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _isLoadingMore
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _loadMoreFacts,
                      child: Text('Load More (${_factsList.length}/$_totalFacts)'),
                    ),
            );
          }

          final fact = _factsList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FutureBuilder<bool>(
              future: _cacheService.isFavorite(fact),
              builder: (context, snapshot) {
                final isFavorite = snapshot.data ?? false;
                return FactCard(
                  fact: fact,
                  isFavorite: isFavorite,
                  onFavorite: () => _toggleFavorite(fact),
                  onShare: () {
                    // TODO: Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing fact...')),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRandomFactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shuffle,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Random Cat Fact',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_isRandomFactLoading)
                    const CircularProgressIndicator()
                  else if (_randomFact != null)...[
                    Text(
                      _randomFact!.factText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FutureBuilder<bool>(
                          future: _cacheService.isFavorite(_randomFact!),
                          builder: (context, snapshot) {
                            final isFavorite = snapshot.data ?? false;
                            return IconButton.filled(
                              onPressed: () => _toggleFavorite(_randomFact!),
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                            );
                          },
                        ),
                        IconButton.filled(
                          onPressed: () {
                            // TODO: Implement share functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sharing fact...')),
                            );
                          },
                          icon: const Icon(Icons.share),
                        ),
                      ],
                    ),
                  ] else
                    const Text(
                      'Tap the button below to get a random cat fact!',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _loadRandomFact,
                    icon: const Icon(Icons.shuffle),
                    label: Text(_randomFact == null ? 'Get Random Fact' : 'Get Another Fact'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    if (_isFavoritesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No favorite facts yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding facts to your favorites by tapping the heart icon!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final fact = _favorites[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FactCard(
              fact: fact,
              isFavorite: true,
              onFavorite: () => _toggleFavorite(fact),
              onShare: () {
                // TODO: Implement share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing fact...')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}