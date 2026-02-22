import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model representing the result of a skin lesion analysis.
///
/// Contains the verdict, confidence score, and metadata returned by the
/// backend after processing an uploaded image.
class AnalysisResult {
  /// Creates an [AnalysisResult].
  const AnalysisResult({
    required this.id,
    required this.verdict,
    required this.confidence,
    required this.createdAt,
    this.recommendation,
    this.imageUrl,
  });

  /// Unique identifier for this analysis (matches the Firestore document ID).
  final String id;

  /// The classification verdict (e.g., "benign", "melanoma").
  final String verdict;

  /// Confidence score as a percentage (0–100).
  final double confidence;

  /// Contextual recommendation based on the analysis outcome.
  ///
  /// May be `null` when the result comes directly from Firestore, as the
  /// backend does not currently generate recommendations.
  final String? recommendation;

  /// Timestamp when the analysis was created.
  final DateTime createdAt;

  /// Path of the uploaded image in Firebase Storage.
  ///
  /// May be `null` if the image has been deleted after processing.
  final String? imageUrl;

  /// Whether the verdict indicates a benign (non-cancerous) classification.
  bool get isBenign => verdict.toLowerCase() == 'benign';

  /// Returns the risk level based on the verdict and confidence score.
  ///
  /// For benign verdicts the scale is inverted — high confidence in
  /// "benign" means low risk (green):
  /// - 61–100% confidence → [RiskLevel.low]
  /// - 31–60% confidence  → [RiskLevel.moderate]
  /// - 0–30% confidence   → [RiskLevel.high]
  ///
  /// For all other (potentially malignant) verdicts:
  /// - 0–30% confidence   → [RiskLevel.low]
  /// - 31–60% confidence  → [RiskLevel.moderate]
  /// - 61–100% confidence → [RiskLevel.high]
  RiskLevel get riskLevel {
    if (isBenign) {
      if (confidence >= 61) return RiskLevel.low;
      if (confidence >= 31) return RiskLevel.moderate;
      return RiskLevel.high;
    }
    if (confidence <= 30) return RiskLevel.low;
    if (confidence <= 60) return RiskLevel.moderate;
    return RiskLevel.high;
  }

  /// Creates an [AnalysisResult] from a Firestore document snapshot.
  ///
  /// Expects the document shape written by the Cloud Run backend:
  /// `{ verdict, confidence, storage_path, createdAt }`.
  factory AnalysisResult.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AnalysisResult(
      id: doc.id,
      verdict: data['verdict'] as String,
      confidence: (data['confidence'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      imageUrl: data['storage_path'] as String?,
      recommendation: null,
    );
  }

  /// Creates an [AnalysisResult] from a JSON map.
  ///
  /// Used for deserializing locally cached results.
  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      id: json['id'] as String,
      verdict: json['verdict'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      recommendation: json['recommendation'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  /// Serializes this [AnalysisResult] to a JSON map.
  ///
  /// Used for writing to local storage cache.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verdict': verdict,
      'confidence': confidence,
      'recommendation': recommendation,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}

/// Classification of risk based on the analysis confidence score.
enum RiskLevel {
  /// Low risk (0–30% confidence).
  low,

  /// Moderate risk (31–60% confidence).
  moderate,

  /// High risk (61–100% confidence).
  high,
}
