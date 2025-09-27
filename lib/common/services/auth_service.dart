import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const String _hasCredentialsKey = 'auth.hasCredentials';

  Future<bool> hasSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCredentialsKey) ?? false;
  }

  Future<void> setHasCredentials(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCredentialsKey, value);
  }
}
