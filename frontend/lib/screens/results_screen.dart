import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../theme/app_theme.dart';
import '../widgets/confidence_gauge.dart';

/// Screen displaying the results of a skin lesion analysis.
///
/// Shows the scanned image, a color-coded [ConfidenceGauge], the verdict,
/// a recommendation card, and actions to scan another image.
class ResultsScreen extends StatelessWidget {
  /// Creates a [ResultsScreen] with the given [result].
  ///
  /// When navigating from a fresh scan, [imageBytes] can be provided
  /// for immediate display. When viewing from history, the image is
  /// loaded from [AnalysisResult.localImagePath].
  const ResultsScreen({
    required this.result,
    this.imageBytes,
    super.key,
  });

  /// The analysis result to display.
  final AnalysisResult result;

  /// Raw image bytes for immediate display from a fresh scan.
  ///
  /// If `null`, the widget falls back to [result.localImagePath].
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                // ── Scanned Image ───────────────────────────────────
                _buildImagePreview(theme),
                const SizedBox(height: 24),

                // ── Confidence Gauge ────────────────────────────────
                ConfidenceGauge(
                  confidence: result.confidence,
                  riskLevel: result.riskLevel,
                ),
                const SizedBox(height: 24),

                // ── Verdict ─────────────────────────────────────────
                Text(
                  result.verdict,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _verdictColor(result.riskLevel),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(result.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Recommendation Card ─────────────────────────────
                Card(
                  color: _recommendationCardColor(
                    result.riskLevel,
                    theme,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _recommendationIcon(result.riskLevel),
                          size: 28,
                          color: _verdictColor(result.riskLevel),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommendation',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                result.recommendation ??
                                    _defaultRecommendation(result.riskLevel),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Actions ─────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.document_scanner),
                    label: const Text('Scan Another'),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Disclaimer ──────────────────────────────────────
                Text(
                  'This result is for informational purposes only and '
                  'should not be used as a medical diagnosis.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    Widget? imageWidget;

    if (imageBytes != null) {
      imageWidget = Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (!kIsWeb &&
        result.localImagePath != null &&
        File(result.localImagePath!).existsSync()) {
      imageWidget = Image.file(
        File(result.localImagePath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (imageWidget == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageWidget,
    );
  }

  Color _verdictColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppTheme.riskLow;
      case RiskLevel.moderate:
        return AppTheme.riskModerate;
      case RiskLevel.high:
        return AppTheme.riskHigh;
    }
  }

  Color _recommendationCardColor(RiskLevel level, ThemeData theme) {
    switch (level) {
      case RiskLevel.low:
        return AppTheme.riskLow.withValues(alpha: 0.1);
      case RiskLevel.moderate:
        return AppTheme.riskModerate.withValues(alpha: 0.1);
      case RiskLevel.high:
        return AppTheme.riskHigh.withValues(alpha: 0.1);
    }
  }

  IconData _recommendationIcon(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return Icons.check_circle_outline;
      case RiskLevel.moderate:
        return Icons.info_outline;
      case RiskLevel.high:
        return Icons.warning_amber_rounded;
    }
  }

  String _defaultRecommendation(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return 'The lesion appears low-risk. Monitor for changes and consult '
            'a healthcare provider if anything develops.';
      case RiskLevel.moderate:
        return 'The result is inconclusive. Consider visiting a dermatologist '
            'for a professional evaluation.';
      case RiskLevel.high:
        return 'The lesion may require attention. We recommend consulting a '
            'dermatologist as soon as possible for a professional evaluation.';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year} '
        'at $hour:$minute $period';
  }
}
