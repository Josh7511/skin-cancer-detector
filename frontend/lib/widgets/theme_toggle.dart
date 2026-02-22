import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

/// An icon button that toggles between light and dark themes.
///
/// Displays a sun icon in dark mode and a moon icon in light mode.
/// Intended for use in the [AppBar] actions.
class ThemeToggle extends StatelessWidget {
  /// Creates a [ThemeToggle] widget.
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      ),
      tooltip: themeProvider.isDarkMode
          ? 'Switch to light mode'
          : 'Switch to dark mode',
      onPressed: () => themeProvider.toggleTheme(),
    );
  }
}
