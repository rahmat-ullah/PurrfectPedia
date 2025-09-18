import 'package:flutter/material.dart';
import 'encyclopedia_service.dart';
import 'breed_data_expansion_service.dart';

/// Service to initialize the complete encyclopedia system
class EncyclopediaInitializer {
  final EncyclopediaService _encyclopediaService = EncyclopediaService();
  final BreedDataExpansionService _expansionService = BreedDataExpansionService();

  /// Initializes the complete encyclopedia system
  Future<void> initializeCompleteEncyclopedia({
    VoidCallback? onProgress,
    Function(String)? onStatusUpdate,
  }) async {
    try {
      onStatusUpdate?.call('Starting encyclopedia initialization...');
      
      // Step 1: Initialize basic encyclopedia data
      onStatusUpdate?.call('Populating basic breed database...');
      await _encyclopediaService.initializeEncyclopedia();
      onProgress?.call();

      // Step 2: Expand detailed breed information
      onStatusUpdate?.call('Expanding detailed breed information...');
      await _expansionService.expandAllBreedData();
      onProgress?.call();

      // Step 3: Validate data completeness
      onStatusUpdate?.call('Validating breed data...');
      final validation = await _encyclopediaService.validateBreedData();
      onProgress?.call();

      // Step 4: Generate statistics
      onStatusUpdate?.call('Generating breed statistics...');
      final stats = await _encyclopediaService.getBreedStatistics();
      onProgress?.call();

      onStatusUpdate?.call('Encyclopedia initialization completed successfully!');
      
      // Print completion summary
      print('=== ENCYCLOPEDIA INITIALIZATION COMPLETE ===');
      print('Total breeds: ${stats['totalBreeds']}');
      print('Completion rate: ${validation['completionRate']?.toStringAsFixed(1)}%');
      print('Issues found: ${validation['issues']?.length ?? 0}');
      print('Warnings: ${validation['warnings']?.length ?? 0}');
      print('============================================');
      
    } catch (e) {
      onStatusUpdate?.call('Error during initialization: $e');
      print('Encyclopedia initialization failed: $e');
      rethrow;
    }
  }

  /// Quick initialization for development/testing
  Future<void> quickInitialize() async {
    print('Quick encyclopedia initialization...');
    await _encyclopediaService.initializeEncyclopedia();
    print('Quick initialization completed.');
  }

  /// Gets initialization status
  Future<Map<String, dynamic>> getInitializationStatus() async {
    try {
      final breeds = await _encyclopediaService.getAllBreeds();
      final validation = await _encyclopediaService.validateBreedData();
      final stats = await _encyclopediaService.getBreedStatistics();

      return {
        'isInitialized': breeds.isNotEmpty,
        'breedCount': breeds.length,
        'completionRate': validation['completionRate'] ?? 0.0,
        'lastUpdated': DateTime.now().toIso8601String(),
        'statistics': stats,
        'validation': validation,
      };
    } catch (e) {
      return {
        'isInitialized': false,
        'error': e.toString(),
      };
    }
  }

  /// Forces a complete re-initialization
  Future<void> forceReinitialization() async {
    print('Forcing complete encyclopedia re-initialization...');
    
    try {
      // Clear and refresh encyclopedia
      await _encyclopediaService.refreshEncyclopedia();
      
      // Expand all breed data
      await _expansionService.expandAllBreedData();
      
      print('Force re-initialization completed successfully.');
    } catch (e) {
      print('Force re-initialization failed: $e');
      rethrow;
    }
  }
}

/// Widget to show encyclopedia initialization progress
class EncyclopediaInitializationWidget extends StatefulWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onError;

  const EncyclopediaInitializationWidget({
    Key? key,
    this.onComplete,
    this.onError,
  }) : super(key: key);

  @override
  State<EncyclopediaInitializationWidget> createState() => _EncyclopediaInitializationWidgetState();
}

class _EncyclopediaInitializationWidgetState extends State<EncyclopediaInitializationWidget> {
  final EncyclopediaInitializer _initializer = EncyclopediaInitializer();
  
  double _progress = 0.0;
  String _statusMessage = 'Preparing encyclopedia...';
  bool _isInitializing = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkInitializationStatus();
  }

  Future<void> _checkInitializationStatus() async {
    try {
      final status = await _initializer.getInitializationStatus();
      
      if (status['isInitialized'] == true) {
        setState(() {
          _progress = 1.0;
          _statusMessage = 'Encyclopedia ready!';
        });
        widget.onComplete?.call();
      } else {
        _startInitialization();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
      widget.onError?.call();
    }
  }

  Future<void> _startInitialization() async {
    setState(() {
      _isInitializing = true;
      _hasError = false;
      _progress = 0.0;
    });

    try {
      await _initializer.initializeCompleteEncyclopedia(
        onProgress: () {
          setState(() {
            _progress += 0.25; // 4 steps total
          });
        },
        onStatusUpdate: (status) {
          setState(() {
            _statusMessage = status;
          });
        },
      );

      setState(() {
        _progress = 1.0;
        _statusMessage = 'Encyclopedia initialization complete!';
        _isInitializing = false;
      });

      widget.onComplete?.call();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isInitializing = false;
      });
      widget.onError?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    return _buildProgressWidget();
  }

  Widget _buildProgressWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.pets,
            size: 64,
            color: Colors.orange,
          ),
          const SizedBox(height: 24),
          Text(
            'PurrfectPedia Encyclopedia',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _statusMessage,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          const SizedBox(height: 16),
          Text(
            '${(_progress * 100).toInt()}% Complete',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          if (_isInitializing) ...[
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 24),
          Text(
            'Initialization Error',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'An unknown error occurred',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _startInitialization,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
