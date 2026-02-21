import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/analysis_result.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../services/analysis_service.dart';
import '../services/storage_service.dart';
import '../widgets/step_indicator.dart';
import 'results_screen.dart';

/// Multi-step upload wizard for skin lesion analysis.
///
/// Step 1: Select an image from the device.
/// Step 2: Upload and process the image (shows loading animation).
/// Step 3: Navigate to [ResultsScreen] with the analysis result.
class UploadScreen extends StatefulWidget {
  /// Creates an [UploadScreen] widget.
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  static const _stepLabels = ['Select', 'Analyze', 'Results'];

  final _imagePicker = ImagePicker();
  final _storageService = StorageService();
  final _analysisService = AnalysisService();

  int _currentStep = 0;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String _statusMessage = '';
  String? _errorMessage;

  // ── Step 1: Image Selection ─────────────────────────────────────────

  Future<void> _pickImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageName = picked.name;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image. Please try again.';
      });
    }
  }

  // ── Step 2: Upload & Analyze ────────────────────────────────────────

  Future<void> _startAnalysis() async {
    if (_selectedImageBytes == null) return;

    setState(() {
      _currentStep = 1;
      _statusMessage = 'Uploading image...';
      _errorMessage = null;
    });

    try {
      final userId =
          context.read<AuthProvider>().userId ?? 'anonymous';

      // Upload image.
      setState(() => _statusMessage = 'Uploading image...');
      final imageUrl = await _storageService.uploadImage(
        bytes: _selectedImageBytes!,
        filename: _selectedImageName ?? 'image.jpg',
        userId: userId,
      );

      // Analyze image.
      setState(() => _statusMessage = 'Analyzing image...');
      final result = await _analysisService.analyzeImage(imageUrl);

      // Save to history.
      if (mounted) {
        await context.read<HistoryProvider>().addResult(result);
        _navigateToResults(result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentStep = 0;
          _errorMessage = 'Analysis failed. Please try again.';
        });
      }
    }
  }

  void _navigateToResults(AnalysisResult result) {
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ResultsScreen(result: result),
      ),
    );

    // Reset wizard after navigating.
    setState(() {
      _currentStep = 0;
      _selectedImageBytes = null;
      _selectedImageName = null;
      _statusMessage = '';
    });
  }

  void _reset() {
    setState(() {
      _currentStep = 0;
      _selectedImageBytes = null;
      _selectedImageName = null;
      _statusMessage = '';
      _errorMessage = null;
    });
  }

  // ── Build ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              // Step indicator.
              StepIndicator(
                currentStep: _currentStep,
                totalSteps: 3,
                labels: _stepLabels,
              ),
              const SizedBox(height: 32),

              // Step content.
              if (_currentStep == 0) _buildSelectStep(theme),
              if (_currentStep == 1) _buildAnalyzeStep(theme),
            ],
          ),
        ),
      ),
    );
  }

  // ── Step 1 UI ─────────────────────────────────────────────────────

  Widget _buildSelectStep(ThemeData theme) {
    return Column(
      children: [
        // Drop zone / image preview.
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: _selectedImageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.memory(
                      _selectedImageBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 56,
                        color: theme.colorScheme.primary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to select an image',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'JPG, PNG up to 10MB',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),

        // File name display.
        if (_selectedImageName != null)
          Text(
            _selectedImageName!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),

        // Error message.
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Action buttons.
        Row(
          children: [
            if (_selectedImageBytes != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Change'),
                ),
              ),
            if (_selectedImageBytes != null) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    _selectedImageBytes != null ? _startAnalysis : _pickImage,
                icon: Icon(
                  _selectedImageBytes != null
                      ? Icons.science_outlined
                      : Icons.add_photo_alternate_outlined,
                ),
                label: Text(
                  _selectedImageBytes != null ? 'Analyze' : 'Select Image',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Step 2 UI ─────────────────────────────────────────────────────

  Widget _buildAnalyzeStep(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 48),
        SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _statusMessage,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'This may take a few seconds',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 32),
        TextButton(
          onPressed: _reset,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
