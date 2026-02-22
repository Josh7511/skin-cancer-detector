import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/analysis_result.dart';

/// Service responsible for reading analysis results from Cloud Firestore.
///
/// Firestore structure: `results/{analysisId}`
class FirestoreService {
  final _firestore = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'derma');

  /// Waits for the backend to write the result document and returns it.
  ///
  /// Streams `results/{analysisId}` and resolves on the first snapshot where
  /// the document exists. Times out after 2 minutes if the backend does not
  /// respond.
  ///
  /// [analysisId] is the filename stem of the uploaded image, which the
  /// backend uses as the Firestore document ID.
  Future<AnalysisResult> pollResult(String analysisId) {
    return _firestore
        .collection('results')
        .doc(analysisId)
        .withConverter<AnalysisResult>(
          fromFirestore: (snap, _) => AnalysisResult.fromFirestore(snap),
          toFirestore: (result, _) => result.toJson(),
        )
        .snapshots()
        .where((snap) => snap.exists)
        .first
        .timeout(
          const Duration(minutes: 2),
          onTimeout: () => throw TimeoutException(
            'Analysis result not available after 2 minutes. '
            'Please try again.',
          ),
        )
        .then((snap) => snap.data()!);
  }

  /// Retrieves all analysis results ordered by date, most recent first.
  ///
  /// Used by the history screen.
  Future<List<AnalysisResult>> getResults() async {
    final snapshot = await _firestore
        .collection('results')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => AnalysisResult.fromFirestore(doc))
        .toList();
  }
}

/// Thrown when the backend does not write a result within the expected time.
class TimeoutException implements Exception {
  const TimeoutException(this.message);
  final String message;

  @override
  String toString() => message;
}
