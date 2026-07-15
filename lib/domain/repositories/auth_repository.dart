import 'package:echowave/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<void> forgotPassword(String email);
  Future<User?> getUser();
  Future<void> logout();
  Future<bool> isLoggedIn();
}
