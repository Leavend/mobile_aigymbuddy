import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:aigymbuddy/auth/usecases/auth_usecase.dart';
import 'package:aigymbuddy/common/exceptions/app_exceptions.dart';
import 'package:flutter/foundation.dart'; // Added for unawaited

class AuthController extends ChangeNotifier {
  AuthController({required AuthUseCase useCase}) : _useCase = useCase;

  final AuthUseCase _useCase;
  AuthUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _runWithLoading(() async {
      final isLoggedIn = await _useCase.isLoggedIn();
      if (isLoggedIn) {
        // Fetch current user details if needed
        // This would require a new method in the use case
      }
      return Future.value();
    });
  }

  Future<AuthUser> register(SignUpData data) async {
    return _runWithLoading(() async {
      try {
        _clearError();
        final user = await _useCase.register(data);
        _currentUser = user;
        notifyListeners();
        return user;
      } on AuthException catch (e) {
        _setError(e.message);
        rethrow;
      } on ValidationException catch (e) {
        _setError(e.message);
        rethrow;
      } on AppException catch (e) {
        _setError(e.message);
        rethrow;
      }
    });
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    return _runWithLoading(() async {
      try {
        _clearError();
        final user = await _useCase.login(email: email, password: password);
        _currentUser = user;
        notifyListeners();
        return user;
      } on AuthException catch (e) {
        _setError(e.message);
        rethrow;
      } on AppException catch (e) {
        _setError(e.message);
        rethrow;
      }
    });
  }

  Future<void> logout() async {
    try {
      await _useCase.logout();
      _currentUser = null;
      notifyListeners();
    } on AppException catch (e) {
      _setError(e.message);
      rethrow;
    }
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _errorMessage = message;
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
