import 'package:flutter/material.dart';

/// A compact card displaying a single step in the "How It Works" section.
///
/// Uses a horizontal row layout with a numbered icon on the left and
/// a title + description on the right to minimise vertical space.
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: theme.colorScheme.primary,
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$stepNumber',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
