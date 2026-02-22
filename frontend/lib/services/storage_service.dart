import 'dart:typed_data';

/// Service responsible for uploading images to Firebase Cloud Storage.
///
/// Currently returns mock data. Replace the stub implementations with
/// actual Firebase Storage calls when the backend is connected.
class StorageService {
  /// Uploads an image and returns its download URL.
  ///
  /// [bytes] is the raw image data.
  /// [filename] is the original file name.
  /// [userId] is the anonymous user's ID, used for the storage path.
  ///
  /// TODO: Replace with actual Firebase Storage upload:
  /// ```dart
  /// final ref = FirebaseStorage.instance
  ///     .ref('uploads/$userId/${DateTime.now().millisecondsSinceEpoch}_$filename');
  /// final uploadTask = ref.putData(bytes);
  /// final snapshot = await uploadTask;
  /// return await snapshot.ref.getDownloadURL();
  /// ```
  Future<String> uploadImage({
    required Uint8List bytes,
    required String filename,
    required String userId,
  }) async {
    // Simulate upload delay.
    await Future<void>.delayed(const Duration(seconds: 1));

    return 'https://storage.example.com/uploads/$userId/${DateTime.now().millisecondsSinceEpoch}_$filename';
  }
}
