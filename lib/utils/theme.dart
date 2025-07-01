import 'package:flutter/material.dart';

class AppTheme {
  // Primary color schemes for different themes
  static const Map<String, ColorScheme> colorSchemes = {
    'default': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF2196F3),
      onPrimary: Colors.white,
      secondary: Color(0xFF03DAC6),
      onSecondary: Colors.black,
      error: Color(0xFFB00020),
      onError: Colors.white,
      background: Color(0xFFFAFAFA),
      onBackground: Color(0xFF1C1B1F),
      surface: Colors.white,
      onSurface: Color(0xFF1C1B1F),
    ),
    'dark': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF90CAF9),
      onPrimary: Colors.black,
      secondary: Color(0xFF03DAC6),
      onSecondary: Colors.black,
      error: Color(0xFFCF6679),
      onError: Colors.black,
      background: Color(0xFF121212),
      onBackground: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    'ocean': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF006064),
      onPrimary: Colors.white,
      secondary: Color(0xFF00BCD4),
      onSecondary: Colors.black,
      error: Color(0xFFB00020),
      onError: Colors.white,
      background: Color(0xFFE0F7FA),
      onBackground: Color(0xFF1C1B1F),
      surface: Colors.white,
      onSurface: Color(0xFF1C1B1F),
    ),
    'sunset': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFFF6F00),
      onPrimary: Colors.white,
      secondary: Color(0xFFFFB74D),
      onSecondary: Colors.black,
      error: Color(0xFFB00020),
      onError: Colors.white,
      background: Color(0xFFFFF3E0),
      onBackground: Color(0xFF1C1B1F),
      surface: Colors.white,
      onSurface: Color(0xFF1C1B1F),
    ),
    'forest': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF2E7D32),
      onPrimary: Colors.white,
      secondary: Color(0xFF66BB6A),
      onSecondary: Colors.black,
      error: Color(0xFFB00020),
      onError: Colors.white,
      background: Color(0xFFE8F5E8),
      onBackground: Color(0xFF1C1B1F),
      surface: Colors.white,
      onSurface: Color(0xFF1C1B1F),
    ),
    'cyber': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF00FF41),
      onPrimary: Colors.black,
      secondary: Color(0xFF00D4FF),
      onSecondary: Colors.black,
      error: Color(0xFFFF0040),
      onError: Colors.black,
      background: Color(0xFF0A0A0A),
      onBackground: Color(0xFF00FF41),
      surface: Color(0xFF1A1A1A),
      onSurface: Color(0xFF00FF41),
    ),
    'minimalist': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF424242),
      onPrimary: Colors.white,
      secondary: Color(0xFF757575),
      onSecondary: Colors.white,
      error: Color(0xFFB00020),
      onError: Colors.white,
      background: Colors.white,
      onBackground: Color(0xFF212121),
      surface: Colors.white,
      onSurface: Color(0xFF212121),
    ),
    'royal': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6A1B9A),
      onPrimary: Colors.white,
      secondary: Color(0xFFFFD700),
      onSecondary: Colors.black,
      error: Color(0xFFB00020),
      onError: Colors.white,
      background: Color(0xFFF3E5F5),
      onBackground: Color(0xFF1C1B1F),
      surface: Colors.white,
      onSurface: Color(0xFF1C1B1F),
    ),
  };

  static ThemeData getTheme(String themeName) {
    final colorScheme = colorSchemes[themeName] ?? colorSchemes['default']!;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: colorScheme.onSurface.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surface,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 16,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primary,
        disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 14,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 14,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withValues(alpha: 0.5);
          }
          return colorScheme.outline.withValues(alpha: 0.3);
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.2),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Get gradient colors for specific themes
  static List<Color> getGradientColors(String themeName) {
    switch (themeName) {
      case 'ocean':
        return [
          const Color(0xFF006064),
          const Color(0xFF00838F),
          const Color(0xFF00BCD4),
        ];
      case 'sunset':
        return [
          const Color(0xFFFF6F00),
          const Color(0xFFFF8F00),
          const Color(0xFFFFB74D),
        ];
      case 'forest':
        return [
          const Color(0xFF2E7D32),
          const Color(0xFF388E3C),
          const Color(0xFF66BB6A),
        ];
      case 'cyber':
        return [
          const Color(0xFF00FF41),
          const Color(0xFF00D4FF),
          const Color(0xFF00FF88),
        ];
      case 'royal':
        return [
          const Color(0xFF6A1B9A),
          const Color(0xFF8E24AA),
          const Color(0xFFFFD700),
        ];
      case 'analytics':
        return [
          const Color(0xFF1976D2),
          const Color(0xFF42A5F5),
          const Color(0xFF90CAF9),
        ];
      case 'collaboration':
        return [
          const Color(0xFF388E3C),
          const Color(0xFF66BB6A),
          const Color(0xFF81C784),
        ];
      case 'categories':
        return [
          const Color(0xFFFF6F00),
          const Color(0xFFFF8F00),
          const Color(0xFFFFB74D),
        ];
      case 'reminders':
        return [
          const Color(0xFFD32F2F),
          const Color(0xFFE57373),
          const Color(0xFFFFCDD2),
        ];
      default:
        return [
          const Color(0xFF2196F3),
          const Color(0xFF03DAC6),
          const Color(0xFF64B5F6),
        ];
    }
  }

  // Get shadow for cards
  static List<BoxShadow> getCardShadow(String themeName) {
    final isDark = themeName == 'dark' || themeName == 'cyber';
    return [
      BoxShadow(
        color: isDark 
          ? Colors.black.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }
} 