/// Data model representing the result of a skin lesion analysis.
///
/// Contains the verdict, confidence score, recommendation, and metadata
/// returned by the backend after processing an uploaded image.
class AnalysisResult {
  /// Creates an [AnalysisResult].
  const AnalysisResult({
    required this.id,
    required this.verdict,
    required this.confidence,
    required this.recommendation,
    required this.createdAt,
    this.imageUrl,
    this.localImagePath,
  });

  /// Unique identifier for this analysis.
  final String id;

  /// The classification verdict (e.g., "Benign", "Potentially Malignant").
  final String verdict;

  /// Confidence score as a percentage (0–100).
  final double confidence;

  /// Contextual recommendation based on the analysis outcome.
  final String recommendation;

  /// Timestamp when the analysis was created.
  final DateTime createdAt;

  /// URL of the uploaded image in Firebase Storage.
  ///
  /// May be `null` if the image has been deleted after processing.
  final String? imageUrl;

  /// Path to the locally saved copy of the scanned image.
  ///
  /// Used for displaying the image in results and history screens
  /// without requiring a network request.
  final String? localImagePath;

  /// Returns a copy of this result with the given fields replaced.
  AnalysisResult copyWith({
    String? id,
    String? verdict,
    double? confidence,
    String? recommendation,
    DateTime? createdAt,
    String? imageUrl,
    String? localImagePath,
  }) {
    return AnalysisResult(
      id: id ?? this.id,
      verdict: verdict ?? this.verdict,
      confidence: confidence ?? this.confidence,
      recommendation: recommendation ?? this.recommendation,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
    );
  }

  /// Returns the risk level based on the confidence score.
  ///
  /// - [RiskLevel.low]: 0–30%
  /// - [RiskLevel.moderate]: 31–60%
  /// - [RiskLevel.high]: 61–100%
  RiskLevel get riskLevel {
    if (confidence <= 30) return RiskLevel.low;
    if (confidence <= 60) return RiskLevel.moderate;
    return RiskLevel.high;
  }

  /// Creates an [AnalysisResult] from a JSON map.
  ///
  /// Used for deserializing Firestore documents and local storage data.
  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      id: json['id'] as String,
      verdict: json['verdict'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      recommendation: json['recommendation'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      localImagePath: json['localImagePath'] as String?,
    );
  }

  /// Serializes this [AnalysisResult] to a JSON map.
  ///
  /// Used for writing to Firestore and local storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verdict': verdict,
      'confidence': confidence,
      'recommendation': recommendation,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
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
