import 'package:aigymbuddy/auth/models/auth_user.dart';
import 'package:aigymbuddy/auth/models/sign_up_data.dart';

abstract class AuthRepositoryInterface {
  Future<AuthUser> register(SignUpData data);
  Future<AuthUser> login({required String email, required String password});
}
