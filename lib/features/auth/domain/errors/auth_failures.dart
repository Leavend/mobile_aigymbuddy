// lib/features/auth/domain/errors/auth_failures.dart

abstract class AuthFailure implements Exception {
  AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class EmailAlreadyInUseFailure extends AuthFailure {
  EmailAlreadyInUseFailure() : super('Email already registered.');
}

class InvalidCredentialsFailure extends AuthFailure {
  InvalidCredentialsFailure() : super('Invalid email or password.');
}

class MissingSignUpDataFailure extends AuthFailure {
  MissingSignUpDataFailure() : super('Missing sign-up context.');
}
