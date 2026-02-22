import '../models/analysis_result.dart';
import 'firestore_service.dart';

/// Service responsible for retrieving image analysis results from the backend.
///
/// After the frontend uploads an image to Firebase Storage, the Cloud Run
/// backend processes it automatically via an Eventarc trigger and writes the
/// result to Firestore. This service polls Firestore until the result appears.
class AnalysisService {
  final _firestoreService = FirestoreService();

  /// Waits for the analysis result for the given [analysisId] and returns it.
  ///
  /// [analysisId] is the filename stem of the uploaded image, which the
  /// backend uses as the Firestore document ID in `results/{analysisId}`.
  Future<AnalysisResult> analyzeImage(String analysisId) =>
      _firestoreService.pollResult(analysisId);
}
