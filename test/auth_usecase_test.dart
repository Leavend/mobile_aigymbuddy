// AuthUseCase unit tests
import 'package:flutter_test/flutter_test.dart';
import 'package:aigymbuddy/auth/usecases/auth_usecase.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'package:aigymbuddy/common/exceptions/app_exceptions.dart';
import 'package:aigymbuddy/common/services/auth_service.dart';
import 'helpers/test_helpers.dart';

class MockAuthService extends AuthService {
  bool _hasCredentials = false;

  @override
  Future<bool> hasSavedCredentials() async => _hasCredentials;

  @override
  Future<void> setHasCredentials(bool value) async {
    _hasCredentials = value;
  }

  @override
  Future<void> clearCredentials() async {
    _hasCredentials = false;
  }
}

void main() {
  group('AuthUseCase', () {
    late MockAuthRepository mockRepo;
    late MockAuthService mockAuthService;
    late AuthUseCaseImpl useCase;

    setUp(() {
      mockRepo = MockFactory.createAuthRepository();
      mockAuthService = MockAuthService();
      useCase = AuthUseCaseImpl(
        repository: mockRepo,
        authService: mockAuthService,
      );
    });

    test('register success returns user', () async {
      final data = SignUpData(
        email: 'test@example.com',
        password: 'pass123',
        firstName: 'Test',
        lastName: 'User',
      );
      mockRepo.mockUser = TestDataBuilders.buildUser(email: data.email);
      final user = await useCase.register(data);
      expect(user.email, data.email);
    });

    test('login propagates repository exception', () async {
      mockRepo.throwOnLogin = AuthException(
        'Invalid credentials',
        AuthException.invalidCredentials,
      );
      expect(
        () => useCase.login(email: 'bad@example.com', password: 'wrong'),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
