import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';
import '../widgets/scan_card.dart';
import 'app_shell.dart';
import 'results_screen.dart';

/// Screen displaying a list of past scan results.
///
/// Results are loaded from [HistoryProvider], which persists data
/// to local storage via [SharedPreferences].
class HistoryScreen extends StatelessWidget {
  /// Creates a [HistoryScreen] widget.
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final historyProvider = context.watch<HistoryProvider>();

    // Loading state.
    if (historyProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Empty state.
    if (historyProvider.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    // Results list.
    return Column(
      children: [
        // Header with clear button.
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 12, 0),
          child: Row(
            children: [
              Text(
                '${historyProvider.results.length} '
                '${historyProvider.results.length == 1 ? 'scan' : 'scans'}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _confirmClear(context, historyProvider),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),

        // List.
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: historyProvider.results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final result = historyProvider.results[index];
              return ScanCard(
                result: result,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ResultsScreen(result: result),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No scans yet',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your scan history will appear here after '
              'you analyze your first image.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => AppShell.switchTab(context, AppShell.scanTab),
              icon: const Icon(Icons.document_scanner),
              label: const Text('Start Your First Scan'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClear(
    BuildContext context,
    HistoryProvider historyProvider,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear History'),
          content: const Text(
            'Are you sure you want to delete all scan history? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                historyProvider.clearHistory();
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
