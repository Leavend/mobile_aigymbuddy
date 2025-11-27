/// Exception for email already being used during registration
class EmailAlreadyUsed implements Exception {}

/// Exception for invalid credentials during login
class InvalidCredentials implements Exception {}

/// Exception for incomplete sign-up data
class IncompleteSignUpData implements Exception {
  IncompleteSignUpData(this.missingFields)
    : assert(missingFields.isNotEmpty, 'missingFields cannot be empty');

  final List<String> missingFields;

  @override
  String toString() =>
      'IncompleteSignUpData(missing: ${missingFields.join(', ')})';
}
