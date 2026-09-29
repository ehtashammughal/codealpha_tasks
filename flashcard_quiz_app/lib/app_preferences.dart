import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _themeKey = 'selected_theme';
  static const String _navigationButtonsKey =
      'show_card_navigation_buttons';

  static final SharedPreferencesAsync _prefs =
      SharedPreferencesAsync();

  // ----------------------------------------------------------
  // THEME
  // ----------------------------------------------------------

  static Future<String?> getTheme() async {
    return await _prefs.getString(_themeKey);
  }

  static Future<void> saveTheme(String theme) async {
    await _prefs.setString(_themeKey, theme);
  }

  // ----------------------------------------------------------
  // PREVIOUS / NEXT BUTTONS
  // ----------------------------------------------------------

  static Future<bool?> getShowNavigationButtons() async {
    return await _prefs.getBool(_navigationButtonsKey);
  }

  static Future<void> saveShowNavigationButtons(
    bool value,
  ) async {
    await _prefs.setBool(
      _navigationButtonsKey,
      value,
    );
  }
}