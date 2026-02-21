import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/analysis_result.dart';
import '../theme/app_theme.dart';

/// An animated circular gauge displaying the analysis confidence score.
///
/// The gauge is color-coded based on the risk level:
/// - Green for [RiskLevel.low] (0-30%)
/// - Amber for [RiskLevel.moderate] (31-60%)
/// - Red for [RiskLevel.high] (61-100%)
class ConfidenceGauge extends StatelessWidget {
  /// Creates a [ConfidenceGauge].
  const ConfidenceGauge({
    required this.confidence,
    required this.riskLevel,
    this.radius = 100.0,
    this.lineWidth = 12.0,
    this.animationDuration = 1200,
    super.key,
  });

  /// The confidence score as a percentage (0-100).
  final double confidence;

  /// The risk level determining the gauge color.
  final RiskLevel riskLevel;

  /// Radius of the circular gauge.
  final double radius;

  /// Width of the progress arc.
  final double lineWidth;

  /// Duration of the fill animation in milliseconds.
  final int animationDuration;

  /// Returns the color corresponding to the [riskLevel].
  Color get _gaugeColor {
    switch (riskLevel) {
      case RiskLevel.low:
        return AppTheme.riskLow;
      case RiskLevel.moderate:
        return AppTheme.riskModerate;
      case RiskLevel.high:
        return AppTheme.riskHigh;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      percent: confidence / 100,
      animation: true,
      animationDuration: animationDuration,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: _gaugeColor,
      backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${confidence.toStringAsFixed(1)}%',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _gaugeColor,
            ),
          ),
          Text(
            _riskLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  String get _riskLabel {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.moderate:
        return 'Moderate Risk';
      case RiskLevel.high:
        return 'High Risk';
    }
  }
}
