// lib/features/auth/data/datasources/session_local_data_source.dart

import 'package:shared_preferences/shared_preferences.dart';

typedef SharedPreferencesFactory = Future<SharedPreferences> Function();

class SessionLocalDataSource {
  SessionLocalDataSource({SharedPreferencesFactory? preferencesFactory})
      : _preferencesFactory =
            preferencesFactory ?? SharedPreferences.getInstance;

  final SharedPreferencesFactory _preferencesFactory;

  static const String _userIdKey = 'session.activeUserId';
  static const String _onboardingKey = 'session.onboardingComplete';

  Future<SharedPreferences> get _prefs async => _preferencesFactory();

  Future<void> persistActiveUser(String userId) async {
    final prefs = await _prefs;
    await prefs.setString(_userIdKey, userId);
  }

  Future<String?> readActiveUserId() async {
    final prefs = await _prefs;
    return prefs.getString(_userIdKey);
  }

  Future<void> clearSession() async {
    final prefs = await _prefs;
    await prefs.remove(_userIdKey);
    await prefs.remove(_onboardingKey);
  }

  Future<void> setOnboardingComplete(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_onboardingKey, value);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await _prefs;
    return prefs.getBool(_onboardingKey) ?? false;
  }
}
