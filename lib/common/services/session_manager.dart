import 'dart:async';
import 'dart:convert';

import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/common/services/logging_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Session manager for secure token storage and session lifecycle management
class SessionManager {
  SessionManager({
    FlutterSecureStorage? secureStorage,
    SharedPreferencesFactory? preferencesFactory,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _preferencesFactory =
            preferencesFactory ?? SharedPreferences.getInstance;

  // Storage keys
  static const String _tokenKey = 'session.token';
  static const String _tokenExpiryKey = 'session.token_expiry';
  static const String _userDataKey = 'session.user_data';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferencesFactory _preferencesFactory;

  Timer? _sessionTimer;
  final _sessionExpiredController = StreamController<void>.broadcast();

  /// Stream that emits when session expires
  Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  /// Save auth token securely with optional expiry
  Future<void> saveToken(String token, {Duration? expiresIn}) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);

      if (expiresIn != null) {
        final expiryTime =
            DateTime.now().add(expiresIn).millisecondsSinceEpoch;
        final prefs = await _preferencesFactory();
        await prefs.setInt(_tokenExpiryKey, expiryTime);
      }

      LoggingService.instance.info('Token saved successfully');
    } catch (e, stackTrace) {
      LoggingService.instance.error(
        'Failed to save token',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Retrieve auth token
  Future<String?> getToken() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token != null && await isTokenExpired()) {
        LoggingService.instance.warning('Token found but expired');
        await clearToken();
        return null;
      }
      return token;
    } catch (e, stackTrace) {
      LoggingService.instance.error(
        'Failed to retrieve token',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Clear auth token
  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      final prefs = await _preferencesFactory();
      await prefs.remove(_tokenExpiryKey);
      LoggingService.instance.info('Token cleared');
    } catch (e, stackTrace) {
      LoggingService.instance.error(
        'Failed to clear token',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Check if token is expired
  Future<bool> isTokenExpired() async {
    try {
      final prefs = await _preferencesFactory();
      final expiryTime = prefs.getInt(_tokenExpiryKey);

      if (expiryTime == null) {
        // No expiry set, token doesn't expire
        return false;
      }

      final expiry = DateTime.fromMillisecondsSinceEpoch(expiryTime);
      final isExpired = DateTime.now().isAfter(expiry);

      if (isExpired) {
        LoggingService.instance.warning('Token has expired');
      }

      return isExpired;
    } catch (e, stackTrace) {
      LoggingService.instance.error(
        'Failed to check token expiry',
        error: e,
        stackTrace: stackTrace,
      );
      return true; // Assume expired on error for security
    }
  }

  /// Check if session is valid (has token and not expired)
  Future<bool> isSessionValid() async {
    final token = await getToken();
    return token != null && !await isTokenExpired();
  }

  /// Save user data
  Future<void> saveUserData(AuthUser user) async {
    try {
      final prefs = await _preferencesFactory();
      final userData = jsonEncode({
        'id': user.id,
        'email': user.email,
        'displayName': user.displayName,
      });
      await prefs.setString(_userDataKey, userData);
      LoggingService.instance.info('User data saved');
    } catch (e, stackTrace) {
      LoggingService.instance.error(
        'Failed to save user data',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Retrieve user data
  Future<AuthUser?> getUserData() async {
    try {
      final prefs = await _preferencesFactory();
      final userDataStr = prefs.getString(_userDataKey);

      if (userDataStr == null) return null;

      final userData = jsonDecode(userDataStr) as Map<String, dynamic>;
      return AuthUser(
        id: userData['id'] as String,
        email: userData['email'] as String,
        displayName: userData['displayName'] as String,
      );
    } catch (e, stackTrace) {
      LoggingService.instance.error(
        'Failed to retrieve user data',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Clear all session data
  Future<void> clearSession() async {
    await clearToken();
    final prefs = await _preferencesFactory();
    await prefs.remove(_userDataKey);
    LoggingService.instance.info('Session cleared');
  }

  /// Start monitoring session expiry
  void startSessionMonitor() {
    stopSessionMonitor(); // Stop any existing timer

    _sessionTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkSession(),
    );

    LoggingService.instance.info('Session monitor started');
  }

  /// Stop monitoring session expiry
  void stopSessionMonitor() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    LoggingService.instance.info('Session monitor stopped');
  }

  /// Internal session check
  Future<void> _checkSession() async {
    if (await isTokenExpired()) {
      LoggingService.instance.warning('Session expired, triggering auto-logout');
      await clearSession();
      _sessionExpiredController.add(null);
    }
  }

  /// Get time until token expires
  Future<Duration?> getTimeUntilExpiry() async {
    try {
      final prefs = await _preferencesFactory();
      final expiryTime = prefs.getInt(_tokenExpiryKey);

      if (expiryTime == null) return null;

      final expiry = DateTime.fromMillisecondsSinceEpoch(expiryTime);
      final duration = expiry.difference(DateTime.now());

      return duration.isNegative ? Duration.zero : duration;
    } catch (e) {
      return null;
    }
  }

  /// Cleanup resources
  void dispose() {
    stopSessionMonitor();
    _sessionExpiredController.close();
  }
}

typedef SharedPreferencesFactory = Future<SharedPreferences> Function();
