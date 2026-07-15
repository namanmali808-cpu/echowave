import 'package:echowave/data/datasources/local_datasource.dart';
import 'package:echowave/data/datasources/remote_datasource.dart';
import 'package:echowave/domain/entities/user.dart';
import 'package:echowave/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<User> login(String email, String password) async {
    final userModel = await _remoteDataSource.login(email, password);
    await _localDataSource.saveUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<User> register(String name, String email, String password) async {
    final userModel =
        await _remoteDataSource.register(name, email, password);
    await _localDataSource.saveUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _remoteDataSource.forgotPassword(email);
  }

  @override
  Future<User?> getUser() async {
    final userModel = await _localDataSource.getUser();
    return userModel?.toEntity();
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearAuth();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _localDataSource.getToken();
    if (token == null || token.isEmpty) return false;
    return true;
  }
}
