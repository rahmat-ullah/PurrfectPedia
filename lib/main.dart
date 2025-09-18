import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purrfect_pedia/services/theme_provider.dart';
import 'package:purrfect_pedia/providers/breed_provider.dart';
import 'package:purrfect_pedia/providers/facts_provider.dart';
import 'package:purrfect_pedia/screens/home_screen.dart';
import 'package:purrfect_pedia/screens/auth_screen.dart';
import 'package:purrfect_pedia/screens/onboarding_screen_1.dart';
import 'package:purrfect_pedia/screens/onboarding_screen_2.dart';
import 'package:purrfect_pedia/services/onboarding_service.dart';
import 'package:purrfect_pedia/services/encyclopedia_initializer.dart';
import 'package:purrfect_pedia/theme/app_theme.dart';
import 'package:purrfect_pedia/widgets/error_boundary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ThemeModePreference is not directly used in main.dart but good to have if needed later.
// import 'package:purrfect_pedia/models/theme_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(); // Initialize Firebase

  // ThemeProvider initialization remains
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();

  // Initialize encyclopedia database in background
  _initializeEncyclopediaInBackground();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => BreedProvider()),
        ChangeNotifierProvider(create: (_) => FactsProvider()),
      ],
      child: const PurrfectPediaApp(), // MaterialApp will be built inside PurrfectPediaApp
    ),
  );
}

/// Initializes the encyclopedia database in the background
void _initializeEncyclopediaInBackground() {
  final initializer = EncyclopediaInitializer();

  // Run initialization in background without blocking app startup
  initializer.quickInitialize().then((_) {
    print('Encyclopedia initialized successfully in background');
  }).catchError((error) {
    print('Encyclopedia initialization failed: $error');
    // App will still work without encyclopedia, user can retry later
  });
}

class PurrfectPediaApp extends StatelessWidget {
  const PurrfectPediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Theme configuration moved to AppTheme class


    return MaterialApp(
      title: 'PurrfectPedia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      // Define named routes
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
      },
      // PRODUCTION AUTHENTICATION AND ONBOARDING LOGIC
      home: ErrorBoundary(
        onError: (error, stackTrace) {
          // Log error for debugging
          debugPrint('App Error: $error');
          debugPrint('StackTrace: $stackTrace');
        },
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Show loading indicator while checking auth state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (snapshot.hasData) { // User is logged in
              // Now check onboarding status
              return FutureBuilder<bool>(
                future: OnboardingService().isOnboardingComplete(),
                builder: (context, onboardingSnapshot) {
                  if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(body: Center(child: CircularProgressIndicator()));
                  }
                  // If onboarding is complete, or if there's an error reading status (default to home)
                  if (onboardingSnapshot.data == true) {
                    return const HomeScreen(); // Navigate to home
                  } else {
                    return const OnboardingScreen1(); // Navigate to onboarding
                  }
                },
              );
            } else { // User is not logged in
              return const AuthScreen(); // Navigate to auth screen
            }
          },
        ),
      ),
    );
  }
}
