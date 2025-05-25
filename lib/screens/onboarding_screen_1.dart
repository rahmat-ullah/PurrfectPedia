import 'package:flutter/material.dart';
import 'package:purrfect_pedia/services/onboarding_service.dart'; // Import OnboardingService

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  void _handleOptionSelected(BuildContext context, String option) {
    print('Selected: $option');
    // Assuming '/onboarding2' will be a defined route for the next screen.
    // If this screen is part of a larger onboarding flow managed by a PageView or similar,
    // this navigation might be handled differently (e.g., by a PageController).
    Navigator.pushReplacementNamed(context, '/onboarding2');
  }

  // Updated _skipOnboarding to be async and call OnboardingService
  void _skipOnboarding(BuildContext context) async {
    final OnboardingService onboardingService = OnboardingService();
    await onboardingService.markOnboardingComplete();
    print('Onboarding skipped and marked as complete.');
    // Assuming '/home' is the defined route for the HomeScreen.
    // Ensure context is still valid if operations are long, though SharedPreferences is usually fast.
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
        actions: [
          TextButton(
            onPressed: () => _skipOnboarding(context),
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.white), // Adjust color to fit AppBar theme
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'What are you most interested in?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () => _handleOptionSelected(context, 'Learning about Cat Breeds'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Learning about Cat Breeds'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _handleOptionSelected(context, 'Daily Cat Facts'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Daily Cat Facts'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _handleOptionSelected(context, 'Identifying Cat Breeds'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Identifying Cat Breeds'),
              ),
              // The skip button is in the AppBar, but if preferred at the bottom:
              // const SizedBox(height: 48.0),
              // TextButton(
              //   onPressed: () => _skipOnboarding(context),
              //   child: const Text('Skip for now'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
