import 'package:flutter/material.dart';
import '../models/cat_fact.dart';

class FactCard extends StatelessWidget {
  final CatFact fact;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const FactCard({
    super.key,
    required this.fact,
    this.onShare,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryStyle = _getCategoryStyle(fact.category, theme);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fact Text
            Text(
              fact.factText,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Bottom Row with Category and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: categoryStyle.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    fact.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: categoryStyle.textColor,
                    ),
                  ),
                ),
                
                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onFavorite != null)
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite 
                              ? Colors.red 
                              : theme.iconTheme.color ?? theme.colorScheme.onSurface.withOpacity(0.7),
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

  _CategoryStyle _getCategoryStyle(String category, ThemeData theme) {
    switch (category.toLowerCase()) {
      case 'health':
        return _CategoryStyle(
          backgroundColor: theme.colorScheme.errorContainer,
          textColor: theme.colorScheme.onErrorContainer,
        );
      case 'behavior':
        return _CategoryStyle(
          backgroundColor: theme.colorScheme.tertiaryContainer,
          textColor: theme.colorScheme.onTertiaryContainer,
        );
      case 'history':
        return _CategoryStyle(
          backgroundColor: theme.colorScheme.secondaryContainer,
          textColor: theme.colorScheme.onSecondaryContainer,
        );
      case 'fun':
        return _CategoryStyle(
          backgroundColor: theme.colorScheme.primaryContainer,
          textColor: theme.colorScheme.onPrimaryContainer,
        );
      case 'daily':
        return _CategoryStyle(
          backgroundColor: theme.colorScheme.primaryContainer,
          textColor: theme.colorScheme.onPrimaryContainer,
        );
      case 'general':
      default:
        return _CategoryStyle(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          textColor: theme.colorScheme.onSurfaceVariant,
        );
    }
  }
}

class _CategoryStyle {
  final Color backgroundColor;
  final Color textColor;

  _CategoryStyle({required this.backgroundColor, required this.textColor});
}