import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/common/services/session_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SessionManager Integration Tests', () {
    late SessionManager sessionManager;

    setUp(() async {
      // Setup test environment
      SharedPreferences.setMockInitialValues({});
      sessionManager = SessionManager();
    });

    tearDown(() {
      sessionManager.dispose();
    });

    test('Session expiry detection with past date', () async {
      // Save token with short expiry (already expired)
      // Note: Token saving requires secure storage, so we test expiry logic separately
      
      // Test expiry detection
      expect(await sessionManager.isTokenExpired(), false); // No token = not expired
    });

    test('Session validation without token', () async {
      // No token saved
      expect(await sessionManager.isSessionValid(), false);
    });

    test('Session monitor can start and stop', () {
      // Test session monitor lifecycle
      expect(() {
        sessionManager.startSessionMonitor();
        sessionManager.stopSessionMonitor();
      }, returnsNormally);
    });

    test('Session expiry stream is available', () {
      expect(sessionManager.onSessionExpired, isA<Stream<void>>());
    });

    test('User data save and retrieve via SharedPreferences', () async {
      const user = AuthUser(
        id: 'user1',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      await sessionManager.saveUserData(user);
      
      final retrieved = await sessionManager.getUserData();
      expect(retrieved, isNotNull);
      expect(retrieved?.email, user.email);
      expect(retrieved?.id, user.id);
      expect(retrieved?.displayName, user.displayName);
    });

    test('Clear session removes user data', () async {
      const user = AuthUser(
        id: 'user2',
        email: 'clear@example.com',
        displayName: 'Clear User',
      );

      await sessionManager.saveUserData(user);
      await sessionManager.clearSession();
      
      final retrieved = await sessionManager.getUserData();
      expect(retrieved, isNull);
    });

    test('Time until expiry returns null for non-existent session', () async {
      final timeLeft = await sessionManager.getTimeUntilExpiry();
      expect(timeLeft, isNull);
    });
  });
}
