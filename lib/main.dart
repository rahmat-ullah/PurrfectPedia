import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purrfect_pedia/services/theme_provider.dart';
import 'package:purrfect_pedia/screens/home_screen.dart';
import 'package:purrfect_pedia/screens/auth_screen.dart';
import 'package:purrfect_pedia/screens/onboarding_screen_1.dart';
import 'package:purrfect_pedia/screens/onboarding_screen_2.dart';
import 'package:purrfect_pedia/services/onboarding_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ThemeModePreference is not directly used in main.dart but good to have if needed later.
// import 'package:purrfect_pedia/models/theme_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  // ThemeProvider initialization remains
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: const PurrfectPediaApp(), // MaterialApp will be built inside PurrfectPediaApp
    ),
  );
}

class PurrfectPediaApp extends StatelessWidget {
  const PurrfectPediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Theme definitions (lightTheme, darkTheme) remain the same as before
    // For brevity, I'm omitting the full theme data here, but it should be retained.
    // Assume lightTheme and darkTheme are defined as they were previously.
    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueGrey[700], // #546E7A
      scaffoldBackgroundColor: Colors.white, 
      colorScheme: ColorScheme.light(
        primary: Colors.blueGrey[700]!, 
        secondary: Colors.blueGrey[600]!, 
        background: Colors.white, 
        surface: Colors.grey[100]!, 
        onPrimary: Colors.white,
        onSecondary: Colors.white, 
        onBackground: Colors.black87,
        onSurface: Colors.black87, 
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[700], 
        foregroundColor: Colors.white, 
        elevation: 0, 
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.grey[100], 
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[700], 
          foregroundColor: Colors.white, 
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blueGrey[700], 
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      useMaterial3: true,
    );

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF433D8B),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF433D8B),
        secondary: const Color(0xFFC8ACD6),
        background: const Color(0xFF17153B),
        surface: const Color(0xFF2E236C),
        onPrimary: Colors.white, 
        onSecondary: Colors.black, 
        onBackground: Colors.white, 
        onSurface: Colors.white, 
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF433D8B), 
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white, 
        ),
        iconTheme: IconThemeData(color: Colors.white), 
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0xFF2E236C), 
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: const Color(0xFFC8ACD6), 
          foregroundColor: Colors.black, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: Color(0xFFC8ACD6), 
        foregroundColor: Colors.black,
      ),
      useMaterial3: true,
    );


    return MaterialApp(
      title: 'PurrfectPedia',
      debugShowCheckedModeBanner: false,
      theme: lightTheme, // Retain your light theme
      darkTheme: darkTheme, // Retain your dark theme
      themeMode: themeProvider.themeMode,
      // Define named routes
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
      },
      // Dynamic initial routing logic
      home: StreamBuilder<User?>(
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
    );
  }
}
