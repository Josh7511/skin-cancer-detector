import 'dart:math';

import '../models/analysis_result.dart';

/// Service responsible for requesting image analysis from the backend.
///
/// This is the primary backend integration point. Currently returns
/// mock data. Replace the stub implementation with an actual HTTP call
/// to the Cloud Function endpoint when the backend is ready.
class AnalysisService {
  final _random = Random();

  /// Sends an image for analysis and returns the result.
  ///
  /// [imageUrl] is the Firebase Storage download URL of the uploaded image.
  ///
  /// TODO: Replace with actual backend call:
  /// ```dart
  /// final response = await http.post(
  ///   Uri.parse('YOUR_CLOUD_FUNCTION_URL/analyze'),
  ///   headers: {'Content-Type': 'application/json'},
  ///   body: jsonEncode({'imageUrl': imageUrl}),
  /// );
  /// final data = jsonDecode(response.body) as Map<String, dynamic>;
  /// return AnalysisResult.fromJson(data);
  /// ```
  Future<AnalysisResult> analyzeImage(String imageUrl) async {
    // Simulate backend processing delay (2–3 seconds).
    await Future<void>.delayed(
      Duration(milliseconds: 2000 + _random.nextInt(1000)),
    );

    // Generate mock result.
    final confidence = _random.nextDouble() * 100;
    final isMalignant = confidence > 50;

    return AnalysisResult(
      id: 'analysis-${DateTime.now().millisecondsSinceEpoch}',
      verdict: isMalignant ? 'Potentially Malignant' : 'Likely Benign',
      confidence: double.parse(confidence.toStringAsFixed(1)),
      recommendation: isMalignant
          ? 'We recommend consulting a dermatologist as soon as possible '
              'for a professional evaluation.'
          : 'The lesion appears benign, but if you have concerns, '
              'consider visiting a healthcare provider for peace of mind.',
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
    );
  }
}
