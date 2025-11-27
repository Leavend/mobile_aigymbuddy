// Basic smoke test
import 'package:aigymbuddy/auth/controllers/auth_controller.dart';
import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:aigymbuddy/auth/repositories/auth_repository_interface.dart';
import 'package:aigymbuddy/auth/usecases/auth_usecase.dart';
import 'package:aigymbuddy/common/di/service_locator.dart';
import 'package:aigymbuddy/database/app_db.dart';
import 'package:aigymbuddy/database/database_service.dart';
import 'package:aigymbuddy/database/repositories/user_profile_repository.dart';
import 'package:aigymbuddy/main.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple mocks
class MockAuthRepository implements AuthRepositoryInterface {
  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: '1', email: email, displayName: 'Test');
  }

  @override
  Future<AuthUser> register(SignUpData data) async {
    return AuthUser(id: '1', email: data.email, displayName: data.displayName);
  }
}

class MockAuthUseCase implements AuthUseCase {
  @override
  Future<bool> isLoggedIn() async => false;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: '1', email: email, displayName: 'Test');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthUser> register(SignUpData data) async {
    return AuthUser(id: '1', email: data.email, displayName: data.displayName);
  }
}

class MockUserProfileRepository extends UserProfileRepository {
  MockUserProfileRepository(super.db);

  @override
  Future<AuthUser?> getUserProfile(String userId) async {
    return AuthUser(
      id: userId,
      email: 'test@test.com',
      displayName: 'Test User',
    );
  }

  @override
  Future<void> updateProfile(AuthUser user) async {}
}

void main() {
  setUp(() {
    ServiceLocator().reset();
  });

  testWidgets('App smoke test - builds without crashing', (
    WidgetTester tester,
  ) async {
    // Setup dependencies
    final db = AppDatabase.forTesting(
      DatabaseConnection(NativeDatabase.memory()),
    );

    final mockAuthUseCase = MockAuthUseCase();
    final mockAuthRepo = MockAuthRepository();
    final mockDbService = DatabaseService(db);
    final authController = AuthController(useCase: mockAuthUseCase);

    await ServiceLocator().initialize();

    // Register test dependencies using cascades
    ServiceLocator()
      ..registerDatabase(db)
      ..registerDatabaseService(mockDbService)
      ..registerAuthRepository(mockAuthRepo)
      ..registerAuthUseCase(mockAuthUseCase)
      ..registerUserProfileRepository(MockUserProfileRepository(db))
      ..registerAuthController(authController);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(db: db, initialLocation: '/onboarding'));

    // Verify that the app builds
    expect(find.byType(MyApp), findsOneWidget);

    // Clean up
    authController.dispose();
    await db.close();
  });
}
