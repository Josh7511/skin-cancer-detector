import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../theme/app_theme.dart';

/// A compact card displaying a summary of a past scan result.
///
/// Shows an image thumbnail (or risk icon fallback), the verdict,
/// confidence badge, date, and a chevron. Tapping triggers [onTap].
class ScanCard extends StatelessWidget {
  /// Creates a [ScanCard].
  const ScanCard({
    required this.result,
    required this.onTap,
    super.key,
  });

  /// The analysis result to display.
  final AnalysisResult result;

  /// Callback invoked when the card is tapped.
  final VoidCallback onTap;

  Color get _riskColor {
    switch (result.riskLevel) {
      case RiskLevel.low:
        return AppTheme.riskLow;
      case RiskLevel.moderate:
        return AppTheme.riskModerate;
      case RiskLevel.high:
        return AppTheme.riskHigh;
    }
  }

  IconData get _riskIcon {
    switch (result.riskLevel) {
      case RiskLevel.low:
        return Icons.check_circle;
      case RiskLevel.moderate:
        return Icons.info;
      case RiskLevel.high:
        return Icons.warning_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image thumbnail or risk icon fallback.
              _buildThumbnail(),
              const SizedBox(width: 16),

              // Verdict and date.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.verdict,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(result.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),

              // Confidence badge.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _riskColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${result.confidence.toStringAsFixed(1)}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _riskColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final hasLocalImage = !kIsWeb &&
        result.localImagePath != null &&
        File(result.localImagePath!).existsSync();

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _riskColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasLocalImage
          ? Image.file(
              File(result.localImagePath!),
              fit: BoxFit.cover,
              width: 48,
              height: 48,
            )
          : Icon(
              _riskIcon,
              color: _riskColor,
              size: 28,
            ),
    );
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
    final hour =
        date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year} '
        'at $hour:$minute $period';
  }
}
