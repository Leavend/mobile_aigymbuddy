// test/integration_test/repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/repositories/user_repository.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNotNull;

void main() {
  group('Repository Tests', () {
    late AppDatabase database;
    late UserRepository userRepository;

    setUp(() async {
      // Buat database baru untuk setiap test
      database = AppDatabase.forTesting(
        DatabaseConnection(NativeDatabase.memory()),
      );
      userRepository = UserRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('UserRepository - should create and retrieve user', () async {
      // Arrange
      const email = 'test@example.com';
      const passwordHash = 'hashed_password';

      // Act
      await userRepository.createUser(email: email, passwordHash: passwordHash);

      final users = await userRepository.getAllUsers();
      final user = await userRepository.getUserById(users.first.id);

      // Assert
      expect(users, hasLength(1));
      expect(user, isNotNull);
      expect(user!.email, email);
      expect(user.passwordHash, passwordHash);
    });

    test('UserRepository - should get user count', () async {
      expect(await userRepository.getUserCount(), 0);

      await userRepository.createUser(
        email: 'test1@example.com',
        passwordHash: 'password1',
      );

      expect(await userRepository.getUserCount(), 1);

      await userRepository.createUser(
        email: 'test2@example.com',
        passwordHash: 'password2',
      );

      expect(await userRepository.getUserCount(), 2);
    });

    test('UserRepository - should handle database connection errors', () async {
      // Close the database first
      await database.close();

      // Create a new repository with closed database for testing error handling
      final closedDatabase = AppDatabase.forTesting(
        DatabaseConnection(NativeDatabase.memory()),
      );
      await closedDatabase.close(); // Close it immediately

      final errorRepository = UserRepository(closedDatabase);

      // Test that operations on closed database throw errors
      expect(
        () async => await errorRepository.getAllUsers(),
        throwsA(isA<StateError>()),
      );

      expect(
        () async => await errorRepository.createUser(
          email: 'test@error.com',
          passwordHash: 'password',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('UserRepository - should handle invalid operations', () async {
      // Test duplicate email creation (should handle gracefully)
      const email = 'duplicate@example.com';
      const password1 = 'password1';
      const password2 = 'password2';

      // First creation should succeed
      await userRepository.createUser(email: email, passwordHash: password1);

      // Second creation with same email should update, not fail
      await userRepository.createUser(email: email, passwordHash: password2);

      // Should only have one user with updated password
      final users = await userRepository.getAllUsers();
      expect(users, hasLength(1));
      expect(users.first.email, email);
      expect(users.first.passwordHash, password2);
    });
  });
}
