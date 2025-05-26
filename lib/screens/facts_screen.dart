import 'package:flutter/material.dart';
import '../models/cat_fact.dart';
import '../services/api_service.dart';
import '../widgets/fact_card.dart';

class FactsScreen extends StatefulWidget {
  const FactsScreen({super.key});

  @override
  State<FactsScreen> createState() => _FactsScreenState();
}

class _FactsScreenState extends State<FactsScreen> {
  final ApiService _apiService = ApiService();
  List<CatFact> _facts = [];
  CatFact? _factOfTheDay;
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialFacts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreFacts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialFacts() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1; // Reset current page
    });

    try {
      // Fetch fact of the day
      final factOfTheDay = await _apiService.fetchNinjaFact();
      
      // Fetch first page of facts list
      final factsData = await _apiService.fetchNinjaFactsList(page: _currentPage);
      final List<CatFact> newFacts = factsData['facts'];
      final Map<String, dynamic> pagination = factsData['pagination'];

      setState(() {
        _factOfTheDay = factOfTheDay;
        _facts = newFacts;
        _totalPages = pagination['last_page'] ?? 1; // catfact.ninja uses 'last_page'
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading initial facts: $e')),
        );
      }
    }
  }

  Future<void> _loadFacts() async { // This is for pull-to-refresh
    await _loadInitialFacts(); // Reload everything
  }

  Future<void> _loadMoreFacts() async {
    if (_isLoading || _isFetchingMore || _currentPage >= _totalPages) {
      return;
    }

    setState(() {
      _isFetchingMore = true;
    });

    try {
      _currentPage++;
      final factsData = await _apiService.fetchNinjaFactsList(page: _currentPage);
      final List<CatFact> newFacts = factsData['facts'];
      final Map<String, dynamic> pagination = factsData['pagination'];
      
      setState(() {
        _facts.addAll(newFacts);
        _totalPages = pagination['last_page'] ?? _totalPages;
        _isFetchingMore = false;
      });
    } catch (e) {
      setState(() {
        _isFetchingMore = false;
        _currentPage--; // Revert page increment on error
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading more facts: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Facts Ninja'), // Updated title
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading || _isFetchingMore ? null : _loadFacts, // Disable while loading
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadFacts,
        color: theme.colorScheme.primary,
        child: Column(
          children: [
            // Daily Fact Highlight
            if (_factOfTheDay != null && !_isLoading) ...[
              Container(
                margin: const EdgeInsets.all(16),
                child: Card(
                  color: theme.colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Fact of the Day',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _factOfTheDay!.fact, // Display fact from _factOfTheDay
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text( // Display length
                              "Length: ${_factOfTheDay!.length}",
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.share,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                              onPressed: () {
                                // TODO: Share fact of the day
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Sharing fact of the day...')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            
            // Loading indicator for initial load
            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            // Facts List or Empty State
            else if (_facts.isEmpty && !_isLoading)
               Expanded(
                child: Center(
                  child: Text(
                    'No facts available at the moment.\nPull to refresh!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // Attach scroll controller
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  // Add 1 for the potential loading indicator at the bottom
                  itemCount: _facts.length + (_isFetchingMore || (_currentPage < _totalPages) ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _facts.length) {
                      // This is the item after the last fact
                      if (_isFetchingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (_currentPage < _totalPages) {
                        // Show Load More button if not currently fetching and more pages are available
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton(
                            onPressed: _loadMoreFacts,
                            child: const Text('Load More Facts'),
                          ),
                        );
                      }
                      return const SizedBox.shrink(); // Nothing to show if no more pages and not fetching
                    }

                    final fact = _facts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FactCard(
                        fact: fact,
                        onShare: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sharing: ${fact.fact.substring(0, (fact.fact.length > 50) ? 50 : fact.fact.length)}...')),
                          );
                        },
                        onFavorite: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Favorite feature coming soon!')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to quiz screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quiz feature coming soon!')),
          );
        },
        icon: const Icon(Icons.quiz),
        label: const Text('Take Quiz'),
        // Ensure FAB colors are good, typically handled by theme
        // backgroundColor: theme.colorScheme.primary,
        // foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}