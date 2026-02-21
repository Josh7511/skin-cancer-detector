import '../models/analysis_result.dart';

/// Service responsible for reading and writing analysis results
/// to Cloud Firestore.
///
/// Currently returns mock data. Replace the stub implementations with
/// actual Firestore calls when the backend is connected.
///
/// Firestore structure: `analyses/{userId}/results/{analysisId}`
class FirestoreService {
  /// Saves an analysis result to Firestore.
  ///
  /// TODO: Replace with actual Firestore write:
  /// ```dart
  /// await FirebaseFirestore.instance
  ///     .collection('analyses')
  ///     .doc(userId)
  ///     .collection('results')
  ///     .doc(result.id)
  ///     .set(result.toJson());
  /// ```
  Future<void> saveResult({
    required String userId,
    required AnalysisResult result,
  }) async {
    // No-op stub -- results are only cached locally for now.
  }

  /// Retrieves all analysis results for a given user.
  ///
  /// TODO: Replace with actual Firestore read:
  /// ```dart
  /// final snapshot = await FirebaseFirestore.instance
  ///     .collection('analyses')
  ///     .doc(userId)
  ///     .collection('results')
  ///     .orderBy('createdAt', descending: true)
  ///     .get();
  /// return snapshot.docs
  ///     .map((doc) => AnalysisResult.fromJson(doc.data()))
  ///     .toList();
  /// ```
  Future<List<AnalysisResult>> getResults(String userId) async {
    // Return empty list -- no Firestore connection yet.
    return [];
  }
}
