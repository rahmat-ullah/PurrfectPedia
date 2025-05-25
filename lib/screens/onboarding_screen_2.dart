import 'package:flutter/material.dart';
import 'package:purrfect_pedia/services/onboarding_service.dart'; // Import OnboardingService

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  // Updated _completeOnboarding to be async and call OnboardingService
  void _completeOnboarding(BuildContext context) async {
    final OnboardingService onboardingService = OnboardingService();
    await onboardingService.markOnboardingComplete();
    print('Onboarding completed and marked as complete.');
    // Assuming '/home' is the defined route for the HomeScreen.
    // Ensure context is still valid if operations are long.
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just a little more...'),
        // No back button automatically if this screen replaces the previous one
        // and the previous one was also pushed with replacement.
        // If it's pushed normally, set automaticallyImplyLeading to false if needed.
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Did you know? A group of cats is called a 'clowder'!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),
              ElevatedButton(
                onPressed: () => _completeOnboarding(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Get Started!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
