import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme definitions for light and dark modes.
///
/// Uses a teal primary color with semantic risk-level colors
/// (green, amber, red) for analysis results.
class AppTheme {
  AppTheme._();

  // ── Brand Colors ──────────────────────────────────────────────────────
  static const Color _primaryLight = Color(0xFF00796B);
  static const Color _primaryDark = Color(0xFF4DB6AC);
  static const Color _surfaceLight = Color(0xFFFAFAFA);
  static const Color _surfaceDark = Color(0xFF121212);

  // ── Risk-Level Colors (shared across themes) ──────────────────────────
  static const Color riskLow = Color(0xFF4CAF50);
  static const Color riskModerate = Color(0xFFFFC107);
  static const Color riskHigh = Color(0xFFF44336);

  // ── Light Theme ───────────────────────────────────────────────────────
  static ThemeData get lightTheme => _buildTheme(
        seedColor: _primaryLight,
        brightness: Brightness.light,
        surface: _surfaceLight,
      );

  // ── Dark Theme ────────────────────────────────────────────────────────
  static ThemeData get darkTheme => _buildTheme(
        seedColor: _primaryDark,
        brightness: Brightness.dark,
        surface: _surfaceDark,
      );

  // ── Shared Builder ────────────────────────────────────────────────────
  static ThemeData _buildTheme({
    required Color seedColor,
    required Brightness brightness,
    required Color surface,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      surface: surface,
    );

    final baseTextTheme = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(baseTextTheme),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
