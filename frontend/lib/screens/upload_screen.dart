import 'package:flutter/material.dart';

/// The upload screen where users select and submit images for analysis.
///
/// Will be implemented as a multi-step wizard in a later PR:
/// Step 1: Select image, Step 2: Processing, Step 3: Complete.
class UploadScreen extends StatelessWidget {
  /// Creates an [UploadScreen] widget.
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Upload a Skin Image',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
