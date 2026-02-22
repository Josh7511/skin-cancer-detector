import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

/// Manages anonymous authentication state.
///
/// Wraps [AuthService] and exposes the current user ID and
/// authentication status to the widget tree via [Provider].
class AuthProvider extends ChangeNotifier {
  /// Creates an [AuthProvider] with the given [AuthService].
  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  String? _userId;
  bool _isLoading = false;

  /// The current anonymous user's ID, or `null` if not signed in.
  String? get userId => _userId;

  /// Whether the user is currently authenticated.
  bool get isAuthenticated => _userId != null;

  /// Whether an authentication request is in progress.
  bool get isLoading => _isLoading;

  /// Signs in anonymously and updates the authentication state.
  ///
  /// Called automatically during app initialization.
  Future<void> signIn() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userId = await _authService.signInAnonymously();
    } catch (e) {
      _userId = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs out and clears the authentication state.
  Future<void> signOut() async {
    await _authService.signOut();
    _userId = null;
    notifyListeners();
  }
}
