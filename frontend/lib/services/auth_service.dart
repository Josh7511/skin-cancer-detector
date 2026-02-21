/// Service responsible for Firebase Anonymous Authentication.
///
/// Currently returns mock data. Replace the stub implementations with
/// actual Firebase Auth calls when the backend is connected.
class AuthService {
  String? _currentUserId;

  /// Signs in the user anonymously and returns a user ID.
  ///
  /// TODO: Replace with actual Firebase Anonymous Auth:
  /// ```dart
  /// final credential = await FirebaseAuth.instance.signInAnonymously();
  /// return credential.user!.uid;
  /// ```
  Future<String> signInAnonymously() async {
    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    _currentUserId = 'mock-anonymous-uid-${DateTime.now().millisecondsSinceEpoch}';
    return _currentUserId!;
  }

  /// Returns the current user's ID, or `null` if not signed in.
  ///
  /// TODO: Replace with:
  /// ```dart
  /// return FirebaseAuth.instance.currentUser?.uid;
  /// ```
  String? getCurrentUserId() => _currentUserId;

  /// Signs out the current user.
  ///
  /// TODO: Replace with:
  /// ```dart
  /// await FirebaseAuth.instance.signOut();
  /// ```
  Future<void> signOut() async {
    _currentUserId = null;
  }
}
