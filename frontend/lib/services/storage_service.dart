import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Service responsible for uploading images to Firebase Cloud Storage.
class StorageService {
  /// Uploads an image and returns its download URL.
  ///
  /// [bytes] is the raw image data.
  /// [filename] is the original file name.
  /// [userId] is the anonymous user's ID, used for the storage path.
  Future<String> uploadImage({
    required Uint8List bytes,
    required String filename,
    required String userId,
  }) async {
    final ref = FirebaseStorage.instance
        .ref('uploads/$userId/${DateTime.now().millisecondsSinceEpoch}_$filename');
    final uploadTask = ref.putData(bytes);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
