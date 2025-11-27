import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/common/di/service_locator.dart';
import 'package:aigymbuddy/common/services/session_manager.dart';

/// Service for managing authentication state and session lifecycle
class AuthService {
  AuthService({SessionManager? sessionManager})
      : _sessionManager = sessionManager;

  // Lazy singleton - initialized on first access
  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService(
      sessionManager: ServiceLocator().sessionManager,
    );
    return _instance!;
  }

  final SessionManager? _sessionManager;
  
  SessionManager get sessionManager =>
      _sessionManager ?? ServiceLocator().sessionManager;

  /// Check if user has valid session
  Future<bool> hasSavedCredentials() async {
    return sessionManager.isSessionValid();
  }

  /// Start new session after successful login
  Future<void> startSession({
    required String token,
    required AuthUser user,
    Duration expiresIn = const Duration(days: 7),
  }) async {
    await sessionManager.saveToken(token, expiresIn: expiresIn);
    await sessionManager.saveUserData(user);
    sessionManager.startSessionMonitor();
  }

  /// End current session (logout)
  Future<void> endSession() async {
    sessionManager.stopSessionMonitor();
    await sessionManager.clearSession();
  }

  /// Get current user data from session
  Future<AuthUser?> getCurrentUser() async {
    return sessionManager.getUserData();
  }

  /// Listen to session expiry events
  Stream<void> get onSessionExpired => sessionManager.onSessionExpired;
}
