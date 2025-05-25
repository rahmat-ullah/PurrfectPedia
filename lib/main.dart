import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purrfect_pedia/services/theme_provider.dart';
import 'screens/home_screen.dart';
// ThemeModePreference is not directly used in main.dart but good to have if needed later.
// import 'package:purrfect_pedia/models/theme_preference.dart';

void main() async { // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Important for SharedPreferences
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference(); // Load saved preference

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: const PurrfectPediaApp(),
    ),
  );
}

class PurrfectPediaApp extends StatelessWidget {
  const PurrfectPediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Define New Light Theme
    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueGrey[700], // #546E7A
      scaffoldBackgroundColor: Colors.white, // Or Colors.grey[50] (#FAFAFA)
      colorScheme: ColorScheme.light(
        primary: Colors.blueGrey[700]!, // #546E7A
        secondary: Colors.blueGrey[600]!, // #607D8B (example, can be same as primary)
        background: Colors.white, // Or Colors.grey[50] (#FAFAFA)
        surface: Colors.grey[100]!, // #F5F5F5
        onPrimary: Colors.white,
        onSecondary: Colors.white, // For text/icons on secondary color
        onBackground: Colors.black87,
        onSurface: Colors.black87, // For text/icons on surface color (cards)
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[700], // #546E7A
        foregroundColor: Colors.white, // For title and icons
        elevation: 0, // Or a subtle elevation like 2 or 4
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Ensure icons are white
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.grey[100], // #F5F5F5
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[700], // #546E7A
          foregroundColor: Colors.white, // Text color for elevated button
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blueGrey[700], // #546E7A
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      // fontFamily: 'Poppins', // Keep if font is set up
      useMaterial3: true,
      // Define text themes if needed, for example:
      // textTheme: TextTheme(
      //   bodyLarge: TextStyle(color: Colors.black87),
      //   bodyMedium: TextStyle(color: Colors.grey[800]),
      //   titleMedium: TextStyle(color: Colors.black87),
      //   headlineSmall: TextStyle(color: Colors.black87),
      // ),
    );

    // Define Dark Theme (remains unchanged)
    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF433D8B),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF433D8B),
        secondary: const Color(0xFFC8ACD6),
        background: const Color(0xFF17153B),
        surface: const Color(0xFF2E236C),
        onPrimary: Colors.white, // For text/icons on primary color
        onSecondary: Colors.black, // For text/icons on secondary color
        onBackground: Colors.white, // For text/icons on background color
        onSurface: Colors.white, // For text/icons on surface color
      ),
      // fontFamily: 'Poppins', // Commented out until font files are added
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF433D8B), // Dark theme primary
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white, // Adjusted for dark primary
        ),
        iconTheme: IconThemeData(color: Colors.white), // Adjusted for dark primary
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0xFF2E236C), // Dark theme card/surface
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: const Color(0xFFC8ACD6), // Dark theme secondary/accent
          foregroundColor: Colors.black, // Text color for elevated button
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
        backgroundColor: Color(0xFFC8ACD6), // Dark theme secondary/accent
        foregroundColor: Colors.black,
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'PurrfectPedia',
      debugShowCheckedModeBanner: false,
      theme: lightTheme, 
      darkTheme: darkTheme, 
      themeMode: themeProvider.themeMode, // Use themeMode from provider
      home: const HomeScreen(),
    );
  }
}
