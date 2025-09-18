import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat_breed.dart';

class BreedCard extends StatelessWidget {
  final CatBreed breed;
  final VoidCallback? onTap;
  final bool showFavoriteButton;

  const BreedCard({
    super.key,
    required this.breed,
    this.onTap,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      // Consider setting card color if not inheriting from theme:
      // color: theme.cardColor, 
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  // Placeholder or actual image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.surfaceContainerHighest,
                          theme.colorScheme.surface,
                        ],
                      ),
                    ),
                    child: Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.pets,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  
                  // Favorite Button
                  if (showFavoriteButton)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.8), // Slightly transparent surface
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.favorite_border, color: theme.colorScheme.primary),
                          onPressed: () {
                            // TODO: Toggle favorite
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added ${breed.name} to favorites (themed)'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breed Name and Origin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          breed.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          breed.origin,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Temperament Summary
                  Text(
                    breed.temperamentSummary ?? 'Friendly and adaptable',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Quick Info Row
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.straighten,
                        label: 'Medium',
                        context: context,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.fitness_center,
                        label: '8-12 lbs',
                        context: context,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.favorite,
                        label: 'High',
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required BuildContext context, // context is already available via the build method, can remove if not changing per chip
  }) {
    final theme = Theme.of(context); // Access theme here if needed, or pass as argument
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}