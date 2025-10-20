// lib/features/auth/domain/entities/auth_user.dart

/// Lightweight representation of an authenticated user within the
/// application domain. Only exposes attributes that the UI layers need to
/// reason about while hiding persistence-specific details such as password
/// hashes.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
  });

  final String id;
  final String email;
  final String displayName;
}
