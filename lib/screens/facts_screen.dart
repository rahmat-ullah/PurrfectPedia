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
  bool _isLoading = true;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'General',
    'History',
    'Health',
    'Behavior',
    'Fun',
  ];

  @override
  void initState() {
    super.initState();
    _loadFacts();
  }

  Future<void> _loadFacts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load facts from API and create mock data
      final apiFacts = await _apiService.fetchRandomFacts(count: 5);
      final mockFacts = _createMockFacts();
      
      _facts = [...apiFacts, ...mockFacts];

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading facts: $e')),
        );
      }
    }
  }

  List<CatFact> _createMockFacts() {
    return [
      CatFact(
        id: 'fact_1',
        factText: 'Cats have a third eyelid called a nictitating membrane.',
        category: 'Health',
        dateAdded: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CatFact(
        id: 'fact_2',
        factText: 'A group of cats is called a "clowder".',
        category: 'Fun',
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CatFact(
        id: 'fact_3',
        factText: 'Cats can rotate their ears 180 degrees.',
        category: 'Behavior',
        dateAdded: DateTime.now().subtract(const Duration(days: 3)),
      ),
      CatFact(
        id: 'fact_4',
        factText: 'The ancient Egyptians worshipped cats and considered them sacred.',
        category: 'History',
        dateAdded: DateTime.now().subtract(const Duration(days: 4)),
      ),
      CatFact(
        id: 'fact_5',
        factText: 'Cats spend 70% of their lives sleeping.',
        category: 'Behavior',
        dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  List<CatFact> get _filteredFacts {
    if (_selectedCategory == 'All') {
      return _facts;
    }
    return _facts.where((fact) => fact.category == _selectedCategory).toList();
  }

  Future<void> _loadMoreFacts() async {
    try {
      final newFacts = await _apiService.fetchRandomFacts(count: 3);
      setState(() {
        _facts.addAll(newFacts);
      });
    } catch (e) {
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
        title: const Text('Cat Facts'),
        // backgroundColor: theme.primaryColor, // Already set by theme
        // foregroundColor: Colors.white, // Already set by theme
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFacts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceVariant, // Updated background
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant, // Updated text color
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected 
                                  ? theme.colorScheme.onPrimaryContainer 
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: theme.chipTheme.backgroundColor ?? theme.colorScheme.surface,
                          selectedColor: theme.chipTheme.selectedColor ?? theme.colorScheme.primaryContainer,
                          checkmarkColor: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Daily Fact Highlight
          if (_facts.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.all(16),
              child: Card(
                color: theme.colorScheme.secondaryContainer, // Updated background
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: theme.colorScheme.onSecondaryContainer, // Updated icon color
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Fact of the Day',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSecondaryContainer, // Updated text color
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _facts.first.factText,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSecondaryContainer, // Updated text color
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(
                              _facts.first.category,
                              style: TextStyle(color: theme.colorScheme.onTertiaryContainer),
                            ),
                            backgroundColor: theme.colorScheme.tertiaryContainer, // Updated chip background
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: theme.colorScheme.onSecondaryContainer, // Updated icon color
                            ),
                            onPressed: () {
                              // TODO: Share fact
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sharing fact...')),
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

          // Facts List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary)))
                : _filteredFacts.isEmpty
                    ? Center(
                        child: Text(
                          'No facts found for this category',
                          style: TextStyle(
                            fontSize: 18, 
                            color: theme.colorScheme.onBackground.withOpacity(0.6), // Updated text color
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadFacts,
                        color: theme.colorScheme.primary, // Refresh indicator color
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredFacts.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _filteredFacts.length) {
                              // Load more button
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: ElevatedButton(
                                  onPressed: _loadMoreFacts,
                                  child: const Text('Load More Facts'),
                                  // Style button if needed, usually ElevatedButton adapts well
                                ),
                              );
                            }

                            final fact = _filteredFacts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: FactCard( // FactCard was already updated in a previous step
                                fact: fact,
                                onShare: () {
                                  // TODO: Share specific fact
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Sharing fact...')),
                                  );
                                },
                                onFavorite: () {
                                  // TODO: Add to favorites
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Added to favorites')),
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