// AuthRepository unit tests
import 'package:flutter_test/flutter_test.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('AuthRepository', () {
    late MockAuthRepository mockRepo;

    setUp(() {
      mockRepo = MockFactory.createAuthRepository();
    });

    test('register returns user from mock', () async {
      final data = SignUpData(
        email: 'test@example.com',
        password: 'pass123',
        firstName: 'Test',
        lastName: 'User',
      );
      mockRepo.mockUser = TestDataBuilders.buildUser(email: data.email);
      final user = await mockRepo.register(data);
      expect(user.email, data.email);
    });

    test('login returns user from mock', () async {
      mockRepo.mockUser = TestDataBuilders.buildUser(
        email: 'login@example.com',
      );
      final user = await mockRepo.login(
        email: 'login@example.com',
        password: 'pwd',
      );
      expect(user.email, 'login@example.com');
    });
  });
}
