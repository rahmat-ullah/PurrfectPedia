import 'package:flutter/material.dart';
import '../models/cat_fact.dart';

class FactCard extends StatelessWidget {
  final CatFact fact;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;

  const FactCard({
    super.key,
    required this.fact,
    this.onShare,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryStyle = _getCategoryStyle(fact.category, theme);

    return Card(
      elevation: 2,
      // color: theme.cardColor, // Or rely on global card theme
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fact Text
            Text(
              fact.fact, // Changed from fact.factText
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 8), // Reduced spacing a bit

            // Display Fact Length
            Text(
              "Length: ${fact.length}",
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Bottom Row with Actions (Category Removed)
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align actions to the end
              children: [
                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onFavorite != null)
                      IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color: theme.iconTheme.color ?? theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        onPressed: onFavorite,
                        iconSize: 20,
                      ),
                    if (onShare != null)
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: theme.iconTheme.color ?? theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        onPressed: onShare,
                        iconSize: 20,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // _getCategoryStyle method and _CategoryStyle class are removed
}