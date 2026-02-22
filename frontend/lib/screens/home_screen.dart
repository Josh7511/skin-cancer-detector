import 'package:flutter/material.dart';

import '../widgets/info_step_card.dart';
import 'app_shell.dart';

/// The home screen of the application.
///
/// Displays a welcome hero section, a "Start Scan" call-to-action,
/// a "How It Works" section with three compact step cards, and a brief
/// medical disclaimer banner linking to the About screen.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen] widget.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // ── Hero Section ──────────────────────────────────────
              Icon(
                Icons.health_and_safety,
                size: 88,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                'Derma',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'AI-powered skin lesion analysis',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // ── Start Scan CTA ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      AppShell.switchTab(context, AppShell.scanTab),
                  icon: const Icon(Icons.document_scanner),
                  label: const Text('Start Scan'),
                ),
              ),
              const SizedBox(height: 32),

              // ── How It Works ──────────────────────────────────────
              Text(
                'How It Works',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const InfoStepCard(
                stepNumber: 1,
                icon: Icons.camera_alt_outlined,
                title: 'Upload a Photo',
                description: 'Take or upload a clear photo of the skin '
                    'lesion you want analyzed.',
              ),
              const SizedBox(height: 8),
              const InfoStepCard(
                stepNumber: 2,
                icon: Icons.psychology_outlined,
                title: 'AI Analysis',
                description: 'Our deep learning model analyzes the image '
                    'and classifies the lesion.',
              ),
              const SizedBox(height: 8),
              const InfoStepCard(
                stepNumber: 3,
                icon: Icons.assessment_outlined,
                title: 'Get Results',
                description: 'View your results instantly with a confidence '
                    'score and recommendation.',
              ),
              const SizedBox(height: 32),

              // ── Disclaimer Banner ─────────────────────────────────
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Medical Disclaimer',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'This tool is for informational purposes '
                              'only and is not a substitute for '
                              'professional medical advice.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: theme.colorScheme.onErrorContainer,
                        ),
                        tooltip: 'Learn more',
                        onPressed: () => AppShell.switchTab(
                          context,
                          AppShell.aboutTab,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
