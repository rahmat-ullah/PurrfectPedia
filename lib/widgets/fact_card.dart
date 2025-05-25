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
                    color: _getCategoryColor(fact.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    fact.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getCategoryColor(fact.category),
                    ),
                  ),
                ),
                
                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onFavorite != null)
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: onFavorite,
                        iconSize: 20,
                      ),
                    if (onShare != null)
                      IconButton(
                        icon: const Icon(Icons.share),
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

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Colors.red;
      case 'behavior':
        return Colors.blue;
      case 'history':
        return Colors.orange;
      case 'fun':
        return Colors.purple;
      case 'general':
      default:
        return Colors.green;
    }
  }
} 