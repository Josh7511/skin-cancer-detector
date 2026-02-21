import 'package:flutter/foundation.dart';

import '../models/analysis_result.dart';
import '../services/local_storage_service.dart';

/// Manages the list of past scan results.
///
/// Uses [LocalStorageService] for persistence. When the backend is
/// connected, this provider should also pull from [FirestoreService]
/// as the primary source with local storage as a cache fallback.
class HistoryProvider extends ChangeNotifier {
  /// Creates a [HistoryProvider] with the given [LocalStorageService].
  HistoryProvider({LocalStorageService? localStorageService})
      : _localStorageService = localStorageService ?? LocalStorageService();

  final LocalStorageService _localStorageService;

  List<AnalysisResult> _results = [];
  bool _isLoading = false;

  /// All cached analysis results, most recent first.
  List<AnalysisResult> get results => List.unmodifiable(_results);

  /// Whether history is currently being loaded.
  bool get isLoading => _isLoading;

  /// Whether there are any results in the history.
  bool get isEmpty => _results.isEmpty;

  /// Loads cached results from local storage.
  ///
  /// Should be called once during app initialization.
  ///
  /// TODO: Also fetch from Firestore when backend is connected:
  /// ```dart
  /// final firestoreResults = await _firestoreService.getResults(userId);
  /// if (firestoreResults.isNotEmpty) {
  ///   _results = firestoreResults;
  /// }
  /// ```
  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _results = await _localStorageService.getCachedResults();
    } catch (e) {
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new result to the history and persists it.
  Future<void> addResult(AnalysisResult result) async {
    _results.insert(0, result);
    notifyListeners();

    await _localStorageService.cacheResult(result);
  }

  /// Clears all history from memory and local storage.
  Future<void> clearHistory() async {
    _results = [];
    notifyListeners();

    await _localStorageService.clearCache();
  }
}
