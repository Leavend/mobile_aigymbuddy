// test/integration_test/database_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;

void main() {
  group('Database Integration Tests', () {
    late AppDatabase database;

    setUpAll(() async {
      // Gunakan in-memory database untuk testing
      database = AppDatabase.forTesting(
        DatabaseConnection(NativeDatabase.memory()),
      );
    });

    tearDownAll(() async {
      await database.close();
    });

    group('Database initialization', () {
      testWidgets('should initialize database successfully', (tester) async {
        // Test database connection
        final users = await database.usersDao.getAllUsers();
        expect(users, isA<List<User>>());
        expect(users, isEmpty); // Database baru harus kosong
      });

      testWidgets('should get user count', (tester) async {
        final count = await database.usersDao.getUserCount();
        expect(count, equals(0));
      });
    });

    group('Users operations', () {
      testWidgets('should create and retrieve user', (tester) async {
        // Arrange
        const testEmail = 'test@example.com';
        const testPasswordHash = 'hashed_password';

        // Act - Create user
        await database.usersDao.upsertUser(
          email: testEmail,
          passwordHash: testPasswordHash,
        );

        // Assert - Verify user created
        final users = await database.usersDao.getAllUsers();
        expect(users, hasLength(1));
        expect(users.first.email, equals(testEmail));
        expect(users.first.passwordHash, equals(testPasswordHash));
      });

      testWidgets('should get user by email', (tester) async {
        // Arrange
        const testEmail = 'test2@example.com';
        const testPasswordHash = 'hashed_password2';

        await database.usersDao.upsertUser(
          email: testEmail,
          passwordHash: testPasswordHash,
        );

        // Act
        final user = await database.usersDao.getUserByEmail(testEmail);

        // Assert
        expect(user, isNotNull);
        expect(user!.email, equals(testEmail));
      });

      testWidgets('should update existing user', (tester) async {
        // Arrange
        const testEmail = 'update@example.com';
        const originalPassword = 'original_password';
        const updatedPassword = 'updated_password';

        // Create user
        await database.usersDao.upsertUser(
          email: testEmail,
          passwordHash: originalPassword,
        );

        // Act - Update same user (upsert)
        await database.usersDao.upsertUser(
          email: testEmail,
          passwordHash: updatedPassword,
        );

        // Assert
        final user = await database.usersDao.getUserByEmail(testEmail);
        expect(user, isNotNull);
        expect(user!.passwordHash, equals(updatedPassword));

        // Should still have the same number of users (updated, not created new)
        final allUsers = await database.usersDao.getAllUsers();
        final usersWithEmail = allUsers
            .where((u) => u.email == testEmail)
            .toList();
        expect(usersWithEmail, hasLength(1));
      });
    });

    group('Database cleanup', () {
      testWidgets('should delete user', (tester) async {
        // Arrange
        const testEmail = 'delete@example.com';
        const testPasswordHash = 'delete_password';

        await database.usersDao.upsertUser(
          email: testEmail,
          passwordHash: testPasswordHash,
        );

        final user = await database.usersDao.getUserByEmail(testEmail);
        expect(user, isNotNull);

        // Act
        await database.usersDao.deleteUser(user!.id);

        // Assert
        final deletedUser = await database.usersDao.getUserById(user.id);
        expect(deletedUser, isNull);
      });
    });
  });
}
