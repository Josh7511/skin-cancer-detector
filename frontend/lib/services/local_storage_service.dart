import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/analysis_result.dart';

/// Service responsible for caching analysis results locally using
/// [SharedPreferences].
///
/// This ensures scan history persists across page refreshes even
/// without a Firestore connection.
class LocalStorageService {
  static const String _resultsKey = 'cached_results';

  /// Caches a new [AnalysisResult] to local storage.
  ///
  /// Prepends the result to the existing list so the most recent
  /// scan appears first.
  Future<void> cacheResult(AnalysisResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getCachedResults();
    existing.insert(0, result);

    final encoded = jsonEncode(
      existing.map((r) => r.toJson()).toList(),
    );
    await prefs.setString(_resultsKey, encoded);
  }

  /// Retrieves all cached analysis results from local storage.
  ///
  /// Returns an empty list if no results are cached.
  Future<List<AnalysisResult>> getCachedResults() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_resultsKey);

    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => AnalysisResult.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Clears all cached results from local storage.
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_resultsKey);
  }
}
