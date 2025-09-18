import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/breed.dart';
import '../services/breed_service.dart';

class BreedDetailScreen extends StatefulWidget {
  final Breed breed;

  const BreedDetailScreen({
    super.key,
    required this.breed,
  });

  @override
  State<BreedDetailScreen> createState() => _BreedDetailScreenState();
}

class _BreedDetailScreenState extends State<BreedDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite 
            ? 'Added ${widget.breed.name} to favorites'
            : 'Removed ${widget.breed.name} from favorites',
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: theme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.breed.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: _buildHeroImageCarousel(),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFavorite,
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing breed info...')),
                    );
                  },
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            // Cross Breed Banner
            if (widget.breed.isCrossbreed)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.merge_type, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Cross Breed: ${widget.breed.crossbreedInfo?.generation ?? 'Hybrid'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            
            // Tab Bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: '📋 Overview'),
                Tab(text: '🎨 Appearance'),
                Tab(text: '🐱 Temperament'),
                Tab(text: '🧴 Care'),
                Tab(text: '🏥 Health'),
                Tab(text: '🧬 Breeding'),
                Tab(text: '🔗 Resources'),
              ],
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildAppearanceTab(),
                  _buildTemperamentTab(),
                  _buildCareTab(),
                  _buildHealthTab(),
                  _buildBreedingTab(),
                  _buildResourcesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImageCarousel() {
    return Stack(
      children: [
        PageView.builder(
          controller: _imageController,
          itemCount: widget.breed.images.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final image = widget.breed.images[index];
            return CachedNetworkImage(
              imageUrl: image.url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.pets, size: 64, color: Colors.white),
              ),
            );
          },
        ),
        
        // Image Indicators
        if (widget.breed.images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.breed.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.breed.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.breed.aliases.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Also known as: ${widget.breed.aliases.join(', ')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      _buildInfoItem('Origin', widget.breed.origin, Icons.location_on),
                      const SizedBox(width: 16),
                      _buildInfoItem('Group', widget.breed.breedGroup, Icons.category),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Recognition Badges
                  const Text(
                    'Recognition Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.breed.recognition.map((recognition) {
                      return Chip(
                        label: Text(
                          '${recognition.organization}: ${recognition.status}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: recognition.status == 'recognized'
                            ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2) // Success color with transparency
                            : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2), // Secondary accent with transparency
                        side: BorderSide(
                          color: recognition.status == 'recognized'
                              ? Theme.of(context).colorScheme.tertiary // Success/Positive - Cyan
                              : Theme.of(context).colorScheme.secondary, // Secondary Accent - Soft indigo
                          width: 1,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Stats Row
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Size', widget.breed.appearance.size, Icons.straighten),
                  _buildStatItem('Weight', _getWeightDisplay(), Icons.monitor_weight),
                  _buildStatItem('Lifespan', _getLifespanDisplay(), Icons.schedule),
                  _buildStatItem('Activity', widget.breed.temperament.activityLevel, Icons.directions_run),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // History Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.breed.history,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Fun Facts
          if (widget.breed.funFacts.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fun Facts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.breed.funFacts.map((fact) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Text(fact, style: const TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppearanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Physical Characteristics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Physical Characteristics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildAppearanceRow('Body Type', widget.breed.appearance.bodyType),
                  _buildAppearanceRow('Weight Range', widget.breed.appearance.weightRange),
                  _buildAppearanceRow('Average Height', widget.breed.appearance.averageHeight),
                  _buildAppearanceRow('Size Category', widget.breed.appearance.size),
                  if (widget.breed.weightRangeLbs != null) ...[
                    _buildAppearanceRow('Male Weight', '${widget.breed.weightRangeLbs!.male} lbs'),
                    _buildAppearanceRow('Female Weight', '${widget.breed.weightRangeLbs!.female} lbs'),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Coat Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Coat Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildAppearanceRow('Coat Length', widget.breed.appearance.coatLength),
                  _buildAppearanceRow('Coat Description', widget.breed.appearance.coat),
                  _buildAppearanceRow('Colors', widget.breed.appearance.colors),
                  
                  const SizedBox(height: 16),
                  const Text('Available Colors:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.breed.appearance.coatColors.map((color) {
                      return Chip(
                        label: Text(
                          color,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Features
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Distinctive Features',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('Eye Colors:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.breed.appearance.eyeColors.map((color) {
                      return Chip(
                        label: Text(
                          color,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.7),
                          width: 1,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  const Text('Distinctive Features:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...widget.breed.appearance.distinctiveFeatures.map((feature) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check, size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(feature),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperamentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personality Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personality Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.breed.temperament.summary,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Trait Levels
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personality Traits',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTraitBar('Activity Level', widget.breed.temperament.activityLevel),
                  _buildTraitBar('Vocalization', widget.breed.temperament.vocalizationLevel),
                  _buildTraitBar('Affection Level', widget.breed.temperament.affectionLevel),
                  _buildTraitBar('Intelligence', widget.breed.temperament.intelligence),
                  _buildTraitBar('Trainability', widget.breed.temperament.trainability),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Social Compatibility
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Social Compatibility',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCompatibilityItem('Good with Kids', widget.breed.temperament.socialWithKids),
                  _buildCompatibilityItem('Good with Dogs', widget.breed.temperament.socialWithDogs),
                  _buildCompatibilityItem('Good with Cats', widget.breed.temperament.socialWithCats),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Behavioral Traits
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Behavioral Traits',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.breed.temperament.traits.map((trait) {
                      return Chip(
                        label: Text(
                          trait,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 1,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  if (widget.breed.otherTraits != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Additional Traits',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.breed.otherTraits!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grooming Requirements
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Grooming Requirements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCareItem('Grooming Needs', widget.breed.care.groomingNeeds, Icons.brush),
                  _buildCareItem('Detailed Grooming', widget.breed.care.grooming, Icons.content_cut),
                  _buildCareItem('Shedding Level', widget.breed.care.shedding, Icons.pets),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Exercise & Activity
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exercise & Activity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCareItem('Exercise Needs', widget.breed.care.exerciseNeeds, Icons.directions_run),
                  _buildCareItem('Activity Recommendations', widget.breed.care.exercise, Icons.sports_tennis),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Nutrition
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nutrition',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCareItem('Dietary Notes', widget.breed.care.dietaryNotes, Icons.restaurant),
                  _buildCareItem('Nutrition Guidelines', widget.breed.care.nutrition, Icons.local_dining),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildHealthItem('Lifespan', widget.breed.health.lifespan, Icons.schedule),
                  _buildHealthItem('Veterinary Recommendations', widget.breed.health.veterinaryRecommendations, Icons.local_hospital),
                  _buildHealthItem('Vaccinations', widget.breed.health.vaccinations, Icons.vaccines),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Common Health Issues
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Common Health Issues',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...widget.breed.health.commonIssues.map((issue) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(issue)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Genetic Tests
          if (widget.breed.health.geneticTests.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Genetic Tests',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...widget.breed.health.geneticTests.map((test) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.science, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text(test)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Veterinary Care Schedule
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Veterinary Care Schedule',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildVetCareItem('Deworming', widget.breed.veterinaryCare.dewormingSchedule),
                  _buildVetCareItem('Vaccinations', widget.breed.veterinaryCare.vaccinations),
                  _buildVetCareItem('Dental Care', widget.breed.veterinaryCare.dentalCare),
                  _buildVetCareItem('Parasite Prevention', widget.breed.veterinaryCare.parasitePrevention),
                  _buildVetCareItem('Special Screenings', widget.breed.veterinaryCare.specialScreenings),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Common Medications
          if (widget.breed.commonMedications.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Common Medications & Preventatives',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...widget.breed.commonMedications.map((medication) => 
                      ExpansionTile(
                        title: Text(medication.name),
                        subtitle: Text(medication.purpose),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(medication.usageNotes),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBreedingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cross Breed Information (if applicable)
          if (widget.breed.isCrossbreed && widget.breed.crossbreedInfo != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cross Breed Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildBreedingItem('Generation', widget.breed.crossbreedInfo!.generation ?? 'N/A'),
                    _buildBreedingItem('Primary Parent', widget.breed.crossbreedInfo!.primaryParent ?? 'N/A'),
                    _buildBreedingItem('Secondary Parent', widget.breed.crossbreedInfo!.secondaryParent ?? 'N/A'),
                    _buildBreedingItem('Breeding Purpose', widget.breed.crossbreedInfo!.breedingPurpose ?? 'N/A'),
                    _buildBreedingItem('First Developed', widget.breed.crossbreedInfo!.firstDeveloped ?? 'N/A'),
                    _buildBreedingItem('Breed Stability', widget.breed.crossbreedInfo!.breedStability ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Reproductive Data
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reproductive Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  if (widget.breed.typicalLitterSize != null) ...[
                    _buildBreedingItem('Typical Litter Size', 
                        '${widget.breed.typicalLitterSize!.min}-${widget.breed.typicalLitterSize!.max} (avg: ${widget.breed.typicalLitterSize!.average})'),
                  ],
                  
                  if (widget.breed.gestationPeriod != null) ...[
                    _buildBreedingItem('Gestation Period', 
                        '${widget.breed.gestationPeriod!.min}-${widget.breed.gestationPeriod!.max} days (avg: ${widget.breed.gestationPeriod!.average})'),
                  ],
                  
                  if (widget.breed.reproductiveMaturity != null) ...[
                    _buildBreedingItem('Male Maturity', '${widget.breed.reproductiveMaturity!.maleMonths} months'),
                    _buildBreedingItem('Female Maturity', '${widget.breed.reproductiveMaturity!.femaleMonths} months'),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Breeding Compatibility
          if (widget.breed.breedingCompatibility != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Breeding Compatibility',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Compatible Breeds:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.breed.breedingCompatibility!.compatibleBreeds.map((breed) {
                        return Chip(
                          label: Text(
                            breed,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 1,
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 16),
                    const Text('Genetic Precautions:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...widget.breed.breedingCompatibility!.geneticPrecautions.map((precaution) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(precaution)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Official Recognition
          if (widget.breed.breedStandardLinks.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Official Breed Standards',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...widget.breed.breedStandardLinks.map((link) =>
                      ListTile(
                        leading: const Icon(Icons.link),
                        title: Text(link.organization),
                        subtitle: const Text('View breed standard'),
                        onTap: () => _launchUrl(link.url),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Adoption Resources
          if (widget.breed.adoptionResources.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Adoption Resources',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...widget.breed.adoptionResources.map((resource) =>
                      ListTile(
                        leading: const Icon(Icons.pets),
                        title: Text(resource.name),
                        subtitle: const Text('Find adoptable cats'),
                        onTap: () => _launchUrl(resource.url),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Related Breeds
          if (widget.breed.relatedBreeds.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Related Breeds',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.breed.relatedBreeds.map((breed) {
                        return ActionChip(
                          label: Text(breed),
                          onPressed: () {
                            // TODO: Navigate to related breed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Searching for $breed...')),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Videos
          if (widget.breed.videos.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Videos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...widget.breed.videos.map((video) =>
                      ListTile(
                        leading: const Icon(Icons.play_circle_outline),
                        title: Text(video.caption),
                        subtitle: const Text('Watch video'),
                        onTap: () => _launchUrl(video.url),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAppearanceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildTraitBar(String label, String level) {
    double value = 0.5; // Default
    switch (level.toLowerCase()) {
      case 'low':
        value = 0.3;
        break;
      case 'medium':
        value = 0.6;
        break;
      case 'high':
        value = 0.9;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(level, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityItem(String label, bool compatible) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            compatible ? Icons.check_circle : Icons.cancel,
            color: compatible ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildCareItem(String label, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthItem(String label, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVetCareItem(String label, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(description),
        ],
      ),
    );
  }

  Widget _buildBreedingItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getWeightDisplay() {
    if (widget.breed.weightRangeLbs != null) {
      return '${widget.breed.weightRangeLbs!.male} / ${widget.breed.weightRangeLbs!.female} lbs (M/F)';
    }
    return widget.breed.appearance.weightRange;
  }

  String _getLifespanDisplay() {
    if (widget.breed.lifeSpanYears != null) {
      final lifespan = widget.breed.lifeSpanYears!;
      return '${lifespan.min}-${lifespan.max} years';
    }
    return widget.breed.health.lifespan;
  }
} 