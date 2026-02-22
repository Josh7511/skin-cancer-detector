import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the application's theme mode (light/dark) and persists
/// the user's preference to local storage via [SharedPreferences].
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  bool _isLoaded = false;

  /// The current [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// Whether the persisted theme preference has been loaded.
  bool get isLoaded => _isLoaded;

  /// Whether dark mode is currently active.
  ///
  /// Returns `true` when the theme is explicitly set to dark.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Loads the saved theme preference from [SharedPreferences].
  ///
  /// Should be called once during app initialization. Falls back to
  /// [ThemeMode.system] if the stored value is invalid or if loading fails.
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_themeKey);

      if (stored != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.name == stored,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (e) {
      developer.log(
        'Failed to load theme preference',
        error: e,
        name: 'ThemeProvider',
      );
      // Keep default ThemeMode.system on failure.
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Toggles between light and dark mode and persists the choice.
  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, _themeMode.name);
    } catch (e) {
      developer.log(
        'Failed to persist theme preference',
        error: e,
        name: 'ThemeProvider',
      );
      // Theme is already toggled in memory; persistence failure
      // is non-critical — preference will reset on next launch.
    }
  }
}
