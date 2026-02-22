import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Service for saving and managing locally cached scan images.
///
/// Images are stored in the app's documents directory under a
/// `scan_images/` subdirectory, keyed by analysis ID.
class ImageCacheService {
  /// Saves image [bytes] to local storage for the given [analysisId].
  ///
  /// Returns the file path where the image was saved, or `null`
  /// on web (where local file storage is not supported).
  Future<String?> saveImage({
    required Uint8List bytes,
    required String analysisId,
  }) async {
    if (kIsWeb) return null;

    try {
      final dir = await _imageDirectory;
      final file = File('${dir.path}/$analysisId.jpg');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (e) {
      debugPrint('Failed to cache image: $e');
      return null;
    }
  }

  /// Checks whether a cached image exists for the given [path].
  Future<bool> imageExists(String path) async {
    if (kIsWeb) return false;
    return File(path).exists();
  }

  /// Deletes all cached scan images.
  Future<void> clearAll() async {
    if (kIsWeb) return;

    try {
      final dir = await _imageDirectory;
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('Failed to clear image cache: $e');
    }
  }

  Future<Directory> get _imageDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/scan_images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir;
  }
}
