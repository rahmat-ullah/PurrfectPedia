import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat_recognition_result.dart';
import '../models/saved_breed.dart';
import '../services/recognition_service.dart';
import '../services/recognition_history_service.dart';
import '../widgets/recognition_result_card.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  final RecognitionService _recognitionService = RecognitionService();
  final RecognitionHistoryService _historyService = RecognitionHistoryService();

  late TabController _tabController;

  File? _selectedImage;
  bool _isProcessing = false;
  CatRecognitionResult? _recognitionResult;

  List<SavedBreed> _savedBreeds = [];
  List<RecognitionHistory> _recognitionHistory = [];
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeRecognitionService();
    _loadHistoryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeRecognitionService() async {
    try {
      await _recognitionService.initializeModel();
    } catch (e) {
      print('Failed to initialize recognition service: $e');
    }
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
    ].request();
  }

  Future<void> _pickImageFromCamera() async {
    await _requestPermissions();
    
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _recognitionResult = null;
        });
        await _processImage();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to capture image: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    await _requestPermissions();
    
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _recognitionResult = null;
        });
        await _processImage();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to select image: $e');
    }
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final predictions = await _recognitionService.recognizeBreed(_selectedImage!);
      
      final result = _recognitionService.createRecognitionResult(
        imageUrl: _selectedImage!.path,
        predictions: predictions,
      );

      // Save to history
      await _historyService.addRecognitionHistory(result);

      setState(() {
        _recognitionResult = result;
        _isProcessing = false;
      });

      // Refresh history data
      _loadHistoryData();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorSnackBar('Failed to process image: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearResults() {
    setState(() {
      _selectedImage = null;
      _recognitionResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Recognition'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearResults,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.bookmark), text: 'Saved Breeds'),
            Tab(icon: Icon(Icons.history), text: 'History'),
            Tab(icon: Icon(Icons.camera_alt), text: 'Recognize'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSavedBreedsTab(),
          _buildHistoryTab(),
          _buildRecognitionTab(),
        ],
      ),
    );
  }

  Widget _buildSavedBreedsTab() {
    if (_isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadHistoryData,
      child: _savedBreeds.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No saved breeds yet'),
                  SizedBox(height: 8),
                  Text(
                    'Save breeds from recognition results',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _savedBreeds.length,
              itemBuilder: (context, index) {
                final savedBreed = _savedBreeds[index];
                return Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                          child: savedBreed.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: savedBreed.imageUrl!.startsWith('http')
                                      ? CachedNetworkImage(
                                          imageUrl: savedBreed.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) => const Icon(Icons.pets, size: 32),
                                        )
                                      : Image.file(
                                          File(savedBreed.imageUrl!),
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 32),
                                        ),
                                )
                              : const Icon(Icons.pets, size: 32),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              savedBreed.breedName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(savedBreed.confidence * 100).toStringAsFixed(0)}% confidence',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildHistoryTab() {
    if (_isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadHistoryData,
      child: _recognitionHistory.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No recognition history yet'),
                  SizedBox(height: 8),
                  Text(
                    'Start recognizing cat breeds!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _recognitionHistory.length,
              itemBuilder: (context, index) {
                final history = _recognitionHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: history.imageUrl.startsWith('http')
                            ? CachedNetworkImage(
                                imageUrl: history.imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => const Icon(Icons.pets),
                              )
                            : Image.file(
                                File(history.imageUrl),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets),
                              ),
                      ),
                    ),
                    title: Text(
                      history.wasSuccessful
                          ? history.topBreedName ?? 'Breed detected'
                          : 'No breed detected',
                    ),
                    subtitle: Text(
                      _formatHistoryDate(history.recognitionDate),
                    ),
                    trailing: history.wasSuccessful
                        ? Text(
                            '${(history.highestConfidence! * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRecognitionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            // Instructions Card
            if (_selectedImage == null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 64,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Identify Cat Breeds',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Take a photo or select an image from your gallery to identify the cat breed using AI.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Image Display
            if (_selectedImage != null) ...[
              Card(
                clipBehavior: Clip.antiAlias,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _pickImageFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _pickImageFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Processing Indicator
            if (_isProcessing) ...[
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing image...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Recognition Results
            if (_recognitionResult != null && !_isProcessing) ...[
              const Text(
                'Recognition Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              if (_recognitionResult!.predictions.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No cat breed detected in this image. Please try with a clearer image of a cat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              else
                ..._recognitionResult!.predictions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final prediction = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RecognitionResultCard(
                      prediction: prediction,
                      rank: index + 1,
                    ),
                  );
                }),

              const SizedBox(height: 16),

              // Action Buttons for Results
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Save to history
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved to history')),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Share results
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing...')),
                        );
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ],
        ],
      ),
    );
  }

  String _formatHistoryDate(DateTime date) {
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
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _loadHistoryData() async {
    setState(() => _isLoadingHistory = true);

    try {
      await _historyService.initializeTables();

      final results = await Future.wait([
        _historyService.getSavedBreeds(limit: 10),
        _historyService.getRecognitionHistory(limit: 10),
      ]);

      setState(() {
        _savedBreeds = results[0] as List<SavedBreed>;
        _recognitionHistory = results[1] as List<RecognitionHistory>;
        _isLoadingHistory = false;
      });
    } catch (e) {
      setState(() => _isLoadingHistory = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load history: $e')),
        );
      }
    }
  }
}