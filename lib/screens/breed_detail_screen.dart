// lib/screens/breed_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/cat_breed.dart';

class BreedDetailScreen extends StatelessWidget {
  final CatBreed breed;

  const BreedDetailScreen({super.key, required this.breed});

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final String displayValue = value.isNotEmpty ? value : "N/A";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold, // Make label bold
                ),
          ),
          const SizedBox(height: 4), // Increased spacing slightly
          Text(
            displayValue,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                // Example: Add a bit more style to the value if needed
                // color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.breed), // AppBar title remains the breed name
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Display Breed name prominently at the top if not just in AppBar
          // This is optional as AppBar already has it.
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 16.0),
          //   child: Text(
          //     breed.breed,
          //     style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          //   ),
          // ),
          _buildDetailItem(context, 'Country', breed.country),
          const Divider(), // Add dividers for better separation
          _buildDetailItem(context, 'Origin', breed.origin),
          const Divider(),
          _buildDetailItem(context, 'Coat', breed.coat),
          const Divider(),
          _buildDetailItem(context, 'Pattern', breed.pattern),
        ],
      ),
    );
  }
}