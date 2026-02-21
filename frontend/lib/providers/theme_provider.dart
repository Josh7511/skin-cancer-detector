import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the application's theme mode (light/dark) and persists
/// the user's preference to local storage via [SharedPreferences].
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  /// The current [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// Whether dark mode is currently active.
  ///
  /// Returns `true` when the theme is explicitly set to dark.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Loads the saved theme preference from [SharedPreferences].
  ///
  /// Should be called once during app initialization.
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeKey);

    if (stored != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == stored,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  /// Toggles between light and dark mode and persists the choice.
  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _themeMode.name);
  }
}
