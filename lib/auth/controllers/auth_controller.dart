import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'package:aigymbuddy/database/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  AuthController({required AuthRepository repository, AuthService? authService})
    : _repository = repository,
      _authService = authService ?? AuthService.instance;

  final AuthRepository _repository;
  final AuthService _authService;

  AuthUser? _currentUser;
  bool _isLoading = false;

  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<AuthUser> register(SignUpData data) async {
    return _runWithLoading(() async {
      final user = await _repository.register(data);
      _currentUser = user;
      notifyListeners();
      await _authService.setHasCredentials(true);
      return user;
    });
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    return _runWithLoading(() async {
      final user = await _repository.login(email: email, password: password);
      _currentUser = user;
      notifyListeners();
      await _authService.setHasCredentials(true);
      return user;
    });
  }

  Future<void> logout() async {
    _currentUser = null;
    await _authService.clearCredentials();
    notifyListeners();
  }

  Future<T> _runWithLoading<T>(Future<T> Function() action) async {
    _setLoading(true);
    try {
      return await action();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }
}
