import 'package:flutter/material.dart';

import 'app_preferences.dart';

enum AppThemeType {
  light,
  dark,
  blue,
}

class AppTheme {
  // ----------------------------------------------------------
  // CURRENT SELECTED THEME
  // ----------------------------------------------------------

  static final ValueNotifier<AppThemeType> selectedTheme =
      ValueNotifier<AppThemeType>(
    AppThemeType.light,
  );

  // ----------------------------------------------------------
  // PREVIOUS / NEXT BUTTON SETTING
  // ----------------------------------------------------------

  static final ValueNotifier<bool> showCardNavigationButtons =
      ValueNotifier<bool>(false);

  // ----------------------------------------------------------
  // LOAD SAVED PREFERENCES
  // ----------------------------------------------------------

  static Future<void> loadPreferences() async {
    // -------------------------
    // Load theme
    // -------------------------

    final savedTheme = await AppPreferences.getTheme();

    if (savedTheme != null) {
      switch (savedTheme) {
        case 'dark':
          selectedTheme.value = AppThemeType.dark;
          break;

        case 'blue':
          selectedTheme.value = AppThemeType.blue;
          break;

        case 'light':
        default:
          selectedTheme.value = AppThemeType.light;
          break;
      }
    }

    // -------------------------
    // Load navigation buttons
    // -------------------------

    final savedButtons =
        await AppPreferences.getShowNavigationButtons();

    if (savedButtons != null) {
      showCardNavigationButtons.value = savedButtons;
    }
  }

  // ----------------------------------------------------------
  // SAVE THEME
  // ----------------------------------------------------------

  static Future<void> setTheme(
    AppThemeType theme,
  ) async {
    selectedTheme.value = theme;

    await AppPreferences.saveTheme(
      theme.name,
    );
  }

  // ----------------------------------------------------------
  // SAVE NAVIGATION BUTTON SETTING
  // ----------------------------------------------------------

  static Future<void> setShowCardNavigationButtons(
    bool value,
  ) async {
    showCardNavigationButtons.value = value;

    await AppPreferences.saveShowNavigationButtons(
      value,
    );
  }

  // ----------------------------------------------------------
  // CURRENT THEME DATA
  // ----------------------------------------------------------

  static ThemeData get currentTheme {
    switch (selectedTheme.value) {
      case AppThemeType.light:
        return lightTheme;

      case AppThemeType.dark:
        return darkTheme;

      case AppThemeType.blue:
        return blueTheme;
    }
  }

  // ----------------------------------------------------------
  // LIGHT THEME
  // ----------------------------------------------------------

  static ThemeData get lightTheme {
    const primary = Color(0xFF6C3BFF);
    const secondary = Color(0xFF00BFA6);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      secondary: secondary,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: const Color(0xFFF7F5FF),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7F5FF),
        foregroundColor: Color(0xFF211747),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w900,
          color: Color(0xFF211747),
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: Color(0x206C3BFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1EEFF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        height: 72,
        indicatorColor: primary.withValues(alpha: 0.12),
        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  // ----------------------------------------------------------
  // DARK THEME
  // ----------------------------------------------------------

  static ThemeData get darkTheme {
    const primary = Color(0xFFB19AFF);
    const secondary = Color(0xFF57E6CF);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: primary,
      secondary: secondary,
      surface: const Color(0xFF1D1930),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: const Color(0xFF12101D),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF12101D),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF1D1930),
        elevation: 5,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF26213D),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF211747),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF1D1930),
        indicatorColor: Color(0xFF393052),
        height: 72,
      ),
    );
  }

  // ----------------------------------------------------------
  // BLUE THEME
  // ----------------------------------------------------------

  static ThemeData get blueTheme {
    const primary = Color(0xFF087EDE);
    const secondary = Color(0xFF00B8D9);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      secondary: secondary,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: const Color(0xFFEDF7FF),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFEDF7FF),
        foregroundColor: Color(0xFF12385B),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w900,
          color: Color(0xFF12385B),
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: Color(0x20087EDE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEAF6FF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        height: 72,
        indicatorColor: primary.withValues(alpha: 0.12),
        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}