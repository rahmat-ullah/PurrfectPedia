import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/saved_breed.dart';
import '../services/recognition_history_service.dart';
import '../services/breed_service.dart';
import '../widgets/loading_widgets.dart';
import '../screens/recognition_screen.dart';
import '../screens/encyclopedia_screen.dart';
import '../screens/breed_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final RecognitionHistoryService _historyService = RecognitionHistoryService();
  
  UserStats? _userStats;
  List<SavedBreed> _recentSavedBreeds = [];
  List<RecognitionHistory> _recentRecognitions = [];
  DailyCatQuote? _dailyQuote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      await _historyService.initializeTables();
      
      final results = await Future.wait([
        _historyService.getUserStats(),
        _historyService.getSavedBreeds(limit: 6),
        _historyService.getRecognitionHistory(limit: 6),
        _historyService.getDailyQuote(),
      ]);
      
      setState(() {
        _userStats = results[0] as UserStats;
        _recentSavedBreeds = results[1] as List<SavedBreed>;
        _recentRecognitions = results[2] as List<RecognitionHistory>;
        _dailyQuote = results[3] as DailyCatQuote?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load dashboard: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('PurrfectPedia'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    _buildWelcomeSection(),
                    const SizedBox(height: 24),
                    
                    // Daily Quote Section
                    if (_dailyQuote != null) ...[
                      _buildDailyQuoteSection(),
                      const SizedBox(height: 24),
                    ],
                    
                    // Quick Stats Section
                    _buildQuickStatsSection(),
                    const SizedBox(height: 24),
                    
                    // Quick Actions Section
                    _buildQuickActionsSection(),
                    const SizedBox(height: 24),
                    
                    // Recent Recognitions Section
                    _buildRecentRecognitionsSection(),
                    const SizedBox(height: 24),
                    
                    // Recent Saved Breeds Section
                    _buildRecentSavedBreedsSection(),
                    const SizedBox(height: 24),
                    
                    // Featured Breeds Section
                    _buildFeaturedBreedsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWelcomeSection() {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.pets,
                  size: 32,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to PurrfectPedia',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Discover, identify, and learn about cat breeds',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyQuoteSection() {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Daily Cat Quote',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _dailyQuote!.quote.split(' - ').first,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
            if (_dailyQuote!.author != null) ...[
              const SizedBox(height: 8),
              Text(
                '— ${_dailyQuote!.author}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Stats',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Recognitions',
                '${_userStats?.totalRecognitions ?? 0}',
                Icons.camera_alt,
                theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Breeds Found',
                '${_userStats?.breedsDiscovered ?? 0}',
                Icons.pets,
                theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Saved Breeds',
                '${_userStats?.savedBreeds ?? 0}',
                Icons.bookmark,
                theme.colorScheme.tertiary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Success Rate',
                '${(_userStats?.successRate ?? 0 * 100).toStringAsFixed(0)}%',
                Icons.trending_up,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Recognize Breed',
                'Take or upload a photo',
                Icons.camera_alt,
                theme.colorScheme.primary,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RecognitionScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Browse Breeds',
                'Explore cat encyclopedia',
                Icons.book,
                theme.colorScheme.secondary,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EncyclopediaScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentRecognitionsSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Recognitions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_recentRecognitions.isNotEmpty)
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full recognition history
                },
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_recentRecognitions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No recognitions yet',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start by taking a photo of a cat!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recentRecognitions.length,
              itemBuilder: (context, index) {
                final recognition = _recentRecognitions[index];
                return Container(
                  width: 200,
                  margin: EdgeInsets.only(right: index < _recentRecognitions.length - 1 ? 12 : 0),
                  child: _buildRecognitionHistoryCard(recognition),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRecognitionHistoryCard(RecognitionHistory recognition) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: recognition.imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: recognition.imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                              Icons.pets,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                        : Image.file(
                            File(recognition.imageUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.pets,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recognition.wasSuccessful
                            ? recognition.topBreedName ?? 'Breed detected'
                            : 'No breed detected',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(recognition.recognitionDate),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  recognition.wasSuccessful ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: recognition.wasSuccessful ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  recognition.wasSuccessful
                      ? '${recognition.breedsDetected} breed${recognition.breedsDetected != 1 ? 's' : ''}'
                      : 'Failed',
                  style: theme.textTheme.bodySmall,
                ),
                if (recognition.wasSuccessful && recognition.highestConfidence != null) ...[
                  const Spacer(),
                  Text(
                    '${(recognition.highestConfidence! * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSavedBreedsSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Saved Breeds',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_recentSavedBreeds.isNotEmpty)
              TextButton(
                onPressed: () {
                  // TODO: Navigate to saved breeds screen
                },
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_recentSavedBreeds.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.bookmark_outline,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No saved breeds yet',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Save breeds from recognition results',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _recentSavedBreeds.length,
            itemBuilder: (context, index) {
              final savedBreed = _recentSavedBreeds[index];
              return _buildSavedBreedCard(savedBreed);
            },
          ),
      ],
    );
  }

  Widget _buildSavedBreedCard(SavedBreed savedBreed) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to breed detail
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: savedBreed.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: savedBreed.imageUrl!.startsWith('http')
                              ? CachedNetworkImage(
                                  imageUrl: savedBreed.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.pets,
                                    size: 32,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : Image.file(
                                  File(savedBreed.imageUrl!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.pets,
                                    size: 32,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                        )
                      : Icon(
                          Icons.pets,
                          size: 32,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                savedBreed.breedName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(savedBreed.savedDate),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${(savedBreed.confidence * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedBreedsSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Breeds',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EncyclopediaScreen()),
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder(
          future: BreedService.getAllBreeds(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Featured breeds coming soon!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final breeds = snapshot.data!.take(4).toList();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: breeds.length,
              itemBuilder: (context, index) {
                final breed = breeds[index];
                return Card(
                  elevation: 1,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BreedDetailScreen(breed: breed),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: theme.colorScheme.surfaceContainerHighest,
                              ),
                              child: breed.images.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: breed.images.first.url,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => Icon(
                                          Icons.pets,
                                          size: 32,
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.pets,
                                      size: 32,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            breed.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            breed.origin,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}
