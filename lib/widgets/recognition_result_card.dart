import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/cat_recognition_result.dart';
import '../providers/breed_provider.dart';
import '../screens/breed_detail_screen.dart';
import '../services/breed_service.dart';

class RecognitionResultCard extends StatefulWidget {
  final BreedPrediction prediction;
  final int rank;

  const RecognitionResultCard({
    super.key,
    required this.prediction,
    required this.rank,
  });

  @override
  State<RecognitionResultCard> createState() => _RecognitionResultCardState();
}

class _RecognitionResultCardState extends State<RecognitionResultCard> {
  String? _breedImageUrl;
  bool _isLoadingImage = false;

  @override
  void initState() {
    super.initState();
    _loadBreedImage();
  }

  Future<void> _loadBreedImage() async {
    setState(() => _isLoadingImage = true);

    try {
      // Try to get breed from local database first
      final breed = await BreedService.getBreedById(widget.prediction.breedId);
      if (breed != null && breed.images.isNotEmpty) {
        setState(() {
          _breedImageUrl = breed.images.first.url;
          _isLoadingImage = false;
        });
        return;
      }

      // Fallback: Try to get from provider
      final breedProvider = Provider.of<BreedProvider>(context, listen: false);
      final simpleBread = breedProvider.getBreedById(widget.prediction.breedId);
      if (simpleBread?.imageUrl != null) {
        setState(() {
          _breedImageUrl = simpleBread!.imageUrl;
          _isLoadingImage = false;
        });
        return;
      }
    } catch (e) {
      // Ignore errors and show placeholder
    }

    setState(() => _isLoadingImage = false);
  }

  @override
  Widget build(BuildContext context) {
    final confidencePercentage = (widget.prediction.confidence * 100).round();
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showBreedDetails(context),
        child: Column(
          children: [
            // Main card content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Rank badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getRankColor(widget.rank),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getRankColor(widget.rank).withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${widget.rank}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Breed thumbnail
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildBreedImage(),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Breed info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.prediction.breedName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildQuickSummary(),
                        const SizedBox(height: 8),
                        _buildConfidenceIndicator(confidencePercentage),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Action indicator
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreedImage() {
    if (_isLoadingImage) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_breedImageUrl != null) {
      return CachedNetworkImage(
        imageUrl: _breedImageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.pets,
            size: 30,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.pets,
        size: 30,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildQuickSummary() {
    final theme = Theme.of(context);
    final List<String> summaryItems = [];

    // Add origin if available
    if (widget.prediction.basicInfo?.originCountry != null) {
      summaryItems.add(widget.prediction.basicInfo!.originCountry);
    }

    // Add size if available
    if (widget.prediction.basicInfo?.size != null) {
      summaryItems.add(widget.prediction.basicInfo!.size);
    }

    // Add coat type if available
    if (widget.prediction.physicalCharacteristics?.coatType != null) {
      summaryItems.add('${widget.prediction.physicalCharacteristics!.coatType} coat');
    }

    if (summaryItems.isEmpty) {
      return Text(
        'Cat breed information',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Text(
      summaryItems.join(' • '),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildConfidenceIndicator(int confidencePercentage) {
    final theme = Theme.of(context);
    final confidence = widget.prediction.confidence;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: confidence,
              child: Container(
                decoration: BoxDecoration(
                  color: _getConfidenceColor(confidence),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$confidencePercentage%',
          style: theme.textTheme.labelLarge?.copyWith(
            color: _getConfidenceColor(confidence),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showBreedDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.prediction.breedName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: _buildDetailedContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.prediction.basicInfo != null) ...[
          _buildSectionHeader('Basic Information'),
          _buildBasicInfo(widget.prediction.basicInfo!),
          const SizedBox(height: 24),
        ],
        if (widget.prediction.physicalCharacteristics != null) ...[
          _buildSectionHeader('Physical Characteristics'),
          _buildPhysicalCharacteristics(widget.prediction.physicalCharacteristics!),
          const SizedBox(height: 24),
        ],
        if (widget.prediction.temperament != null) ...[
          _buildSectionHeader('Temperament & Personality'),
          _buildTemperament(widget.prediction.temperament!),
          const SizedBox(height: 24),
        ],
        if (widget.prediction.careRequirements != null) ...[
          _buildSectionHeader('Care Requirements'),
          _buildCareRequirements(widget.prediction.careRequirements!),
          const SizedBox(height: 24),
        ],
        if (widget.prediction.historyBackground != null) ...[
          _buildSectionHeader('History & Background'),
          _buildHistoryBackground(widget.prediction.historyBackground!),
          const SizedBox(height: 24),
        ],
        if (widget.prediction.recognitionStatus != null) ...[
          _buildSectionHeader('Recognition Status'),
          _buildRecognitionStatus(widget.prediction.recognitionStatus!),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _getSectionIcon(title),
            size: 20,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSectionIcon(String title) {
    switch (title.toLowerCase()) {
      case 'basic information':
        return Icons.info_outline;
      case 'physical characteristics':
        return Icons.palette_outlined;
      case 'temperament & personality':
        return Icons.psychology_outlined;
      case 'care requirements':
        return Icons.health_and_safety_outlined;
      case 'history & background':
        return Icons.history_edu_outlined;
      case 'recognition status':
        return Icons.verified_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Widget _buildBasicInfo(BasicInfo basicInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Origin', basicInfo.originCountry),
        _buildInfoRow('Breed Group', basicInfo.breedGroup),
        _buildInfoRow('Size', basicInfo.size),
        _buildInfoRow('Weight Range', basicInfo.weightRange),
      ],
    );
  }

  Widget _buildPhysicalCharacteristics(PhysicalCharacteristics characteristics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Coat Type', characteristics.coatType),
        if (characteristics.coatColors.isNotEmpty)
          _buildInfoRow('Coat Colors', characteristics.coatColors.join(', ')),
        if (characteristics.coatPatterns.isNotEmpty)
          _buildInfoRow('Coat Patterns', characteristics.coatPatterns.join(', ')),
        if (characteristics.eyeColors.isNotEmpty)
          _buildInfoRow('Eye Colors', characteristics.eyeColors.join(', ')),
        if (characteristics.distinctiveFeatures.isNotEmpty)
          _buildInfoRow('Distinctive Features', characteristics.distinctiveFeatures.join(', ')),
      ],
    );
  }

  Widget _buildTemperament(Temperament temperament) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Energy Level', temperament.energyLevel),
        _buildInfoRow('Sociability', temperament.sociability),
        _buildInfoRow('Intelligence', temperament.intelligence),
        _buildInfoRow('Good with Children', temperament.goodWithChildren ? 'Yes' : 'No'),
        _buildInfoRow('Good with Pets', temperament.goodWithPets ? 'Yes' : 'No'),
        if (temperament.personalityTraits.isNotEmpty)
          _buildInfoRow('Personality Traits', temperament.personalityTraits.join(', ')),
      ],
    );
  }

  Widget _buildCareRequirements(CareRequirements care) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Grooming Needs', care.groomingNeeds),
        _buildInfoRow('Exercise Requirements', care.exerciseRequirements),
        if (care.dietaryConsiderations.isNotEmpty)
          _buildInfoRow('Dietary Considerations', care.dietaryConsiderations.join(', ')),
        if (care.commonHealthIssues.isNotEmpty)
          _buildInfoRow('Common Health Issues', care.commonHealthIssues.join(', ')),
      ],
    );
  }

  Widget _buildHistoryBackground(HistoryBackground history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Development History', history.developmentHistory),
        _buildInfoRow('Original Purpose', history.originalPurpose),
        if (history.interestingFacts.isNotEmpty)
          _buildInfoRow('Interesting Facts', history.interestingFacts.join(', ')),
      ],
    );
  }

  Widget _buildRecognitionStatus(RecognitionStatus recognition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('CFA Recognized', recognition.cfaRecognized ? 'Yes' : 'No'),
        _buildInfoRow('TICA Recognized', recognition.ticaRecognized ? 'Yes' : 'No'),
        _buildInfoRow('FIFe Recognized', recognition.fifeRecognized ? 'Yes' : 'No'),
        if (recognition.otherRegistries.isNotEmpty)
          _buildInfoRow('Other Registries', recognition.otherRegistries.join(', ')),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return Colors.green;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}