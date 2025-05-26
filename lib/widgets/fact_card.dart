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
    // The problematic line referencing _getCategoryStyle and fact.category is removed.

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fact.fact,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Length: ${fact.length}",
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7), // Using bodySmall as per previous version
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
}