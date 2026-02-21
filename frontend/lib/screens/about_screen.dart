import 'package:flutter/material.dart';

/// The about screen with medical disclaimer, privacy info, and
/// an explanation of how the AI works.
class AboutScreen extends StatelessWidget {
  /// Creates an [AboutScreen] widget.
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────
              Center(
                child: Icon(
                  Icons.info_outline,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'About Skin Cancer Detector',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // ── How the AI Works ──────────────────────────────────
              _SectionHeader(title: 'How the AI Works', theme: theme),
              const SizedBox(height: 12),
              Text(
                'Our system uses a convolutional neural network (CNN) '
                'trained on dermatological image datasets to classify '
                'skin lesions. When you upload a photo, the image is '
                'preprocessed and fed through the model, which outputs '
                'a classification and a confidence score indicating how '
                'certain the model is about its prediction.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'The confidence score is a percentage from 0% to 100%. '
                'A higher score in the "potentially malignant" category '
                'means the model is more certain the lesion may require '
                'medical attention.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // ── Medical Disclaimer ────────────────────────────────
              _SectionHeader(title: 'Medical Disclaimer', theme: theme),
              const SizedBox(height: 12),
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Important',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This application is intended for educational and '
                        'informational purposes only. It is NOT a medical '
                        'device and should NOT be used as a substitute for '
                        'professional medical advice, diagnosis, or treatment.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Always consult a qualified healthcare provider for '
                        'any concerns about skin lesions or cancer. The AI '
                        "model's predictions are probabilistic and may be "
                        'incorrect.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Privacy ───────────────────────────────────────────
              _SectionHeader(title: 'Your Privacy', theme: theme),
              const SizedBox(height: 12),
              _PrivacyItem(
                icon: Icons.person_off_outlined,
                title: 'Anonymous Accounts',
                description:
                    'You are signed in anonymously. No email, name, or '
                    'personal information is collected.',
                theme: theme,
              ),
              const SizedBox(height: 12),
              _PrivacyItem(
                icon: Icons.delete_outline,
                title: 'Images Deleted After Processing',
                description:
                    'Uploaded images are used solely for analysis and are '
                    'automatically deleted from our servers after processing.',
                theme: theme,
              ),
              const SizedBox(height: 12),
              _PrivacyItem(
                icon: Icons.lock_outline,
                title: 'Results Tied to Session Only',
                description:
                    'Analysis results are linked only to your anonymous '
                    'session ID. No one else can access your data.',
                theme: theme,
              ),
              const SizedBox(height: 32),

              // ── App Info ──────────────────────────────────────────
              Center(
                child: Text(
                  'Skin Cancer Detector v0.1.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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

/// Section header with a horizontal divider.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.theme,
  });

  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// A row item displaying a privacy feature with icon, title, and description.
class _PrivacyItem extends StatelessWidget {
  const _PrivacyItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.theme,
  });

  final IconData icon;
  final String title;
  final String description;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 28,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
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
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
