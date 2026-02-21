import 'package:flutter/material.dart';

/// A horizontal step indicator showing progress through a multi-step flow.
///
/// Each step is rendered as a circle with a connecting line. Steps can be
/// in one of three visual states: completed, active, or pending.
class StepIndicator extends StatelessWidget {
  /// Creates a [StepIndicator].
  const StepIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
    super.key,
  }) : assert(
          labels.length == totalSteps,
          'labels length must equal totalSteps',
        );

  /// The zero-based index of the currently active step.
  final int currentStep;

  /// Total number of steps in the flow.
  final int totalSteps;

  /// Labels displayed beneath each step circle.
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        // Even indices are step circles; odd indices are connecting lines.
        if (index.isOdd) {
          final stepBefore = index ~/ 2;
          final isCompleted = stepBefore < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
          );
        }

        final stepIndex = index ~/ 2;
        final isCompleted = stepIndex < currentStep;
        final isActive = stepIndex == currentStep;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? theme.colorScheme.primary
                    : isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                border: Border.all(
                  color: isCompleted || isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      )
                    : Text(
                        '${stepIndex + 1}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isActive
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              labels[stepIndex],
              style: theme.textTheme.labelSmall?.copyWith(
                color: isCompleted || isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }
}
