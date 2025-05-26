import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingCompleteKey = 'onboardingComplete';

  Future<void> markOnboardingComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
    print('Onboarding status marked as complete.');
  }

  Future<bool> isOnboardingComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Returns the value if it exists, otherwise returns false.
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }
}
