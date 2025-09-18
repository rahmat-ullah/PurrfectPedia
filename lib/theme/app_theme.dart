import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueGrey[700], // #546E7A
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.blueGrey[700]!,
      secondary: Colors.blueGrey[600]!,
      surface: Colors.grey[100]!,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
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

  // Dark Theme with Custom Color Palette
  static ThemeData get darkTheme {
    // Custom dark color scheme based on your specifications
    const ColorScheme darkColorScheme = ColorScheme.dark(
      // Primary colors
      primary: Color(0xFFA855F7),           // Primary Accent - Vibrant violet
      onPrimary: Color(0xFFF9FAFB),         // Primary Text on primary
      primaryContainer: Color(0xFF6366F1),  // Secondary Accent - Soft indigo
      onPrimaryContainer: Color(0xFFF9FAFB),

      // Secondary colors
      secondary: Color(0xFF6366F1),         // Secondary Accent - Soft indigo
      onSecondary: Color(0xFFF9FAFB),
      secondaryContainer: Color(0xFF312E81), // Dividers/Borders
      onSecondaryContainer: Color(0xFFD1D5DB),

      // Tertiary colors
      tertiary: Color(0xFF22D3EE),          // Success/Positive - Cyan
      onTertiary: Color(0xFF0D0B1A),
      tertiaryContainer: Color(0xFF1A1036),
      onTertiaryContainer: Color(0xFFD1D5DB),

      // Error colors
      error: Color(0xFFF87171),             // Error/Warning - Coral red
      onError: Color(0xFFF9FAFB),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFF87171),

      // Background colors
      surface: Color(0xFF1F123D),           // Cards/Containers - Darker violet-tinted
      onSurface: Color(0xFFF9FAFB),         // Primary Text
      onSurfaceVariant: Color(0xFFD1D5DB),  // Secondary Text

      // Surface variants
      surfaceContainerHighest: Color(0xFF1A1036), // Secondary Background
      surfaceContainer: Color(0xFF1F123D),
      surfaceContainerHigh: Color(0xFF2A1B4A),
      surfaceContainerLow: Color(0xFF16102E),
      surfaceContainerLowest: Color(0xFF0D0B1A), // Primary Background

      // Outline colors
      outline: Color(0xFF312E81),           // Dividers/Borders
      outlineVariant: Color(0xFF9CA3AF),    // Tertiary/Disabled Text

      // Other colors
      shadow: Color(0x80000000),            // Card shadows
      scrim: Color(0x80000000),
      inverseSurface: Color(0xFFF9FAFB),
      onInverseSurface: Color(0xFF0D0B1A),
      inversePrimary: Color(0xFF5B21B6),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,

      // Scaffold background
      scaffoldBackgroundColor: const Color(0xFF0D0B1A), // Primary Background

      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF0D0B1A),
        foregroundColor: Color(0xFFF9FAFB),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF9FAFB), // Primary Text
        ),
        iconTheme: IconThemeData(color: Color(0xFFE5E7EB)), // Icons (Default)
      ),

      // Card theme with custom shadows
      cardTheme: CardThemeData(
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        surfaceTintColor: Colors.transparent,
        color: const Color(0xFF1F123D), // Cards/Containers
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA855F7), // Primary Accent
          foregroundColor: const Color(0xFFF9FAFB), // Primary Text
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6366F1), // Secondary Accent
          side: const BorderSide(color: Color(0xFF6366F1)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFA855F7), // Primary Accent
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFA855F7), // Primary Accent
        foregroundColor: Color(0xFFF9FAFB), // Primary Text
        elevation: 6,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1036), // Secondary Background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF312E81)), // Dividers/Borders
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF312E81)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFA855F7), width: 2), // Primary Accent
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF87171)), // Error color
        ),
        labelStyle: const TextStyle(color: Color(0xFFD1D5DB)), // Secondary Text
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // Tertiary/Disabled Text
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: Color(0xFFE5E7EB), // Icons (Default)
        size: 24,
      ),

      // Primary icon theme
      primaryIconTheme: const IconThemeData(
        color: Color(0xFFA855F7), // Icons (Active)
        size: 24,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF312E81), // Dividers/Borders
        thickness: 1,
      ),

      // Bottom navigation bar theme with enhanced contrast
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1036), // Secondary Background - dark violet
        selectedItemColor: Color(0xFFA855F7), // Primary Accent - vibrant violet (high contrast)
        unselectedItemColor: Color(0xFF9CA3AF), // Tertiary/Disabled Text - muted gray
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFA855F7), // Primary Accent for selected label
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9CA3AF), // Tertiary/Disabled Text for unselected label
        ),
        selectedIconTheme: IconThemeData(
          color: Color(0xFFA855F7), // Primary Accent - vibrant violet
          size: 26, // Slightly larger for selected state
        ),
        unselectedIconTheme: IconThemeData(
          color: Color(0xFF9CA3AF), // Tertiary/Disabled Text - muted gray
          size: 24, // Standard size for unselected state
        ),
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF22D3EE), // Success/Positive - Cyan
        linearTrackColor: Color(0xFF312E81),
        circularTrackColor: Color(0xFF312E81),
      ),

      // Snack bar theme
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF1F123D), // Cards/Containers
        contentTextStyle: TextStyle(color: Color(0xFFF9FAFB)), // Primary Text
        actionTextColor: Color(0xFFA855F7), // Primary Accent
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),

      // Text theme with custom colors
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFFF9FAFB)), // Primary Text
        displayMedium: TextStyle(color: Color(0xFFF9FAFB)),
        displaySmall: TextStyle(color: Color(0xFFF9FAFB)),
        headlineLarge: TextStyle(color: Color(0xFFF9FAFB)),
        headlineMedium: TextStyle(color: Color(0xFFF9FAFB)),
        headlineSmall: TextStyle(color: Color(0xFFF9FAFB)),
        titleLarge: TextStyle(color: Color(0xFFF9FAFB)),
        titleMedium: TextStyle(color: Color(0xFFF9FAFB)),
        titleSmall: TextStyle(color: Color(0xFFD1D5DB)), // Secondary Text
        bodyLarge: TextStyle(color: Color(0xFFD1D5DB)), // Secondary Text
        bodyMedium: TextStyle(color: Color(0xFFD1D5DB)),
        bodySmall: TextStyle(color: Color(0xFF9CA3AF)), // Tertiary/Disabled Text
        labelLarge: TextStyle(color: Color(0xFFD1D5DB)),
        labelMedium: TextStyle(color: Color(0xFF9CA3AF)),
        labelSmall: TextStyle(color: Color(0xFF9CA3AF)),
      ),

      // Chip theme for proper contrast in dark mode
      chipTheme: const ChipThemeData(
        backgroundColor: Color(0xFF312E81), // Dividers/Borders - darker background
        selectedColor: Color(0xFF6366F1), // Secondary Accent
        disabledColor: Color(0xFF1A1036), // Secondary Background
        deleteIconColor: Color(0xFFD1D5DB), // Secondary Text
        labelStyle: TextStyle(
          color: Color(0xFFF9FAFB), // Primary Text - high contrast white
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: TextStyle(
          color: Color(0xFFD1D5DB), // Secondary Text
          fontSize: 12,
        ),
        brightness: Brightness.dark,
        elevation: 2,
        pressElevation: 4,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
