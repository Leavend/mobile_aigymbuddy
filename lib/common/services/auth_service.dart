import 'package:shared_preferences/shared_preferences.dart';

typedef SharedPreferencesFactory = Future<SharedPreferences> Function();

class AuthService {
  AuthService({SharedPreferencesFactory? preferencesFactory})
    : _preferencesFactory = preferencesFactory ?? SharedPreferences.getInstance;

  static final AuthService instance = AuthService();

  static const String _hasCredentialsKey = 'auth.hasCredentials';

  final SharedPreferencesFactory _preferencesFactory;

  Future<SharedPreferences> get _prefs async => _preferencesFactory();

  Future<bool> hasSavedCredentials() async {
    final prefs = await _prefs;
    return prefs.getBool(_hasCredentialsKey) ?? false;
  }

  Future<void> setHasCredentials(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_hasCredentialsKey, value);
  }

  Future<void> clearCredentials() => setHasCredentials(false);
}
