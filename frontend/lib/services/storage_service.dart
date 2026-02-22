import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Service responsible for uploading images to Firebase Cloud Storage.
class StorageService {
  /// Uploads an image and returns its download URL and analysis ID.
  ///
  /// [bytes] is the raw image data.
  /// [filename] is the original file name.
  /// [userId] is the anonymous user's ID, used for the storage path.
  ///
  /// Returns a record containing:
  /// - [downloadUrl]: the Firebase Storage download URL.
  /// - [analysisId]: the filename stem (without extension) used as the
  ///   Firestore document ID by the backend.
  Future<({String downloadUrl, String analysisId})> uploadImage({
    required Uint8List bytes,
    required String filename,
    required String userId,
  }) async {
    final storage = FirebaseStorage.instanceFor(
      bucket: 'gs://derma-3fec9.firebasestorage.app',
    );
    final storageName = '${DateTime.now().millisecondsSinceEpoch}_$filename';
    final analysisId = storageName.replaceAll(RegExp(r'\.[^.]+$'), '');
    final ref = storage.ref(storageName);
    final snapshot = await ref.putData(bytes);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return (downloadUrl: downloadUrl, analysisId: analysisId);
  }
}
