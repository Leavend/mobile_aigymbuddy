// lib/auth/usecases/auth_usecase.dart

import 'package:aigymbuddy/auth/exceptions/auth_exceptions.dart';
import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:aigymbuddy/auth/repositories/auth_repository_interface.dart';
import 'package:aigymbuddy/common/exceptions/app_exceptions.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';

/// Use case interface for authentication operations
abstract class AuthUseCase {
  Future<AuthUser> register(SignUpData data);
  Future<AuthUser> login({required String email, required String password});
  Future<void> logout();
  Future<bool> isLoggedIn();
}

/// Implementation of authentication use case
class AuthUseCaseImpl implements AuthUseCase {
  final AuthRepositoryInterface _repository;
  final AuthService _authService;

  AuthUseCaseImpl({
    required AuthRepositoryInterface repository,
    AuthService? authService,
  }) : _repository = repository,
       _authService = authService ?? AuthService.instance;

  @override
  Future<AuthUser> register(SignUpData data) async {
    try {
      final user = await _repository.register(data);
      // Generate token for session
      final token = 'token_${DateTime.now().millisecondsSinceEpoch}_${user.id}';
      await _authService.startSession(
        token: token,
        user: user,
        expiresIn: const Duration(days: 7),
      );
      return user;
    } on EmailAlreadyUsed {
      throw const AuthException(
        'Email already exists',
        AuthException.emailAlreadyUsed,
      );
    } on IncompleteSignUpData {
      throw const ValidationException('Incomplete registration data');
    } on AuthException {
      rethrow;
    } catch (e) {
      throw GenericAppException('Registration failed', e);
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _repository.login(email: email, password: password);
      // Generate token for session
      final token = 'token_${DateTime.now().millisecondsSinceEpoch}_${user.id}';
      await _authService.startSession(
        token: token,
        user: user,
        expiresIn: const Duration(days: 7),
      );
      return user;
    } on InvalidCredentials {
      throw const AuthException(
        'Invalid email or password',
        AuthException.invalidCredentials,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw GenericAppException('Login failed', e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authService.endSession();
    } catch (e) {
      throw GenericAppException('Logout failed', e);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _authService.hasSavedCredentials();
    } catch (e) {
      throw GenericAppException('Failed to check authentication status', e);
    }
  }
}
