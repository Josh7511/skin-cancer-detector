import 'package:flutter/material.dart';

/// A card displaying a single step in the "How It Works" section.
///
/// Shows a numbered icon, a title, and a description arranged
/// vertically within a styled card.
class InfoStepCard extends StatelessWidget {
  /// Creates an [InfoStepCard].
  const InfoStepCard({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  /// The step number displayed in the icon badge.
  final int stepNumber;

  /// The icon representing this step.
  final IconData icon;

  /// Short title for this step.
  final String title;

  /// Longer description of what happens in this step.
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$stepNumber',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
