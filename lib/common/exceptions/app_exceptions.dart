/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final dynamic details;

  const AppException(this.message, [this.details]);

  @override
  String toString() => 'AppException: $message';
}

/// Concrete implementation of AppException for generic application errors
class GenericAppException extends AppException {
  const GenericAppException(super.message, [super.details]);
}

/// Exception for authentication related errors
class AuthException extends AppException {
  const AuthException(super.message, [super.details]);

  /// User credentials are invalid
  static const invalidCredentials = 'INVALID_CREDENTIALS';

  /// Email is already registered
  static const emailAlreadyUsed = 'EMAIL_ALREADY_USED';

  /// User is not authenticated
  static const notAuthenticated = 'NOT_AUTHENTICATED';
}

/// Exception for network related errors
class NetworkException extends AppException {
  NetworkException(super.message, [super.details]);

  /// No internet connection
  static const noInternet = 'NO_INTERNET';

  /// Request timeout
  static const timeout = 'TIMEOUT';

  /// Server error
  static const serverError = 'SERVER_ERROR';
}

/// Exception for data validation errors
class ValidationException extends AppException {
  const ValidationException(super.message, [super.details]);
}
