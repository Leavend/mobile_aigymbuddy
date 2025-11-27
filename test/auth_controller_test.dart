// AuthController unit tests
import 'package:aigymbuddy/auth/controllers/auth_controller.dart';
import 'package:aigymbuddy/common/exceptions/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('AuthController', () {
    late MockAuthUseCase mockUseCase;
    late AuthController controller;

    setUp(() {
      mockUseCase = MockFactory.createAuthUseCase();
      controller = AuthController(useCase: mockUseCase);
    });

    test('login success updates loading and notifies listeners', () async {
      mockUseCase.mockUser = TestDataBuilders.buildUser();
      await controller.login(email: 'test@example.com', password: 'password');
      expect(controller.isLoading, false);
      expect(controller.currentUser?.email, 'test@example.com');
    });

    test('login failure sets error message', () async {
      mockUseCase.throwOnLogin = const AuthException(
        'Invalid credentials',
        AuthException.invalidCredentials,
      );
      await expectLater(
        controller.login(email: 'bad@example.com', password: 'wrong'),
        throwsA(isA<AuthException>()),
      );
      expect(controller.errorMessage, isNotNull);
    });
  });
}
