import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:echowave/data/datasources/local_datasource.dart';
import 'package:echowave/data/models/user_model.dart';
import 'package:echowave/domain/entities/user.dart';

enum AuthState { initial, loading, authenticated, error }

class AuthStateData {
  final AuthState state;
  final User? user;
  final String? errorMessage;

  const AuthStateData({
    this.state = AuthState.initial,
    this.user,
    this.errorMessage,
  });

  AuthStateData copyWith({
    AuthState? state,
    User? user,
    String? errorMessage,
  }) {
    return AuthStateData(
      state: state ?? this.state,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final _localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

class AuthNotifier extends StateNotifier<AuthStateData> {
  final LocalDataSource _localDataSource;
  bool _initialized = false;

  AuthNotifier(this._localDataSource) : super(const AuthStateData());

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _localDataSource.init();
      _initialized = true;
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(state: AuthState.loading, errorMessage: null);
    try {
      await _ensureInitialized();
      await Future.delayed(const Duration(milliseconds: 500));
      final userModel = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email,
        createdAt: DateTime.now(),
      );
      await _localDataSource.saveUser(userModel);
      state = state.copyWith(state: AuthState.authenticated, user: userModel.toEntity());
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: 'Invalid email or password',
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(state: AuthState.loading, errorMessage: null);
    try {
      await _ensureInitialized();
      await Future.delayed(const Duration(milliseconds: 500));
      final userModel = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _localDataSource.saveUser(userModel);
      state = state.copyWith(state: AuthState.authenticated, user: userModel.toEntity());
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: 'Registration failed. Please try again.',
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(state: AuthState.loading, errorMessage: null);
    try {
      await _ensureInitialized();
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(state: AuthState.initial);
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: 'Failed to send reset email',
      );
    }
  }

  Future<void> logout() async {
    await _ensureInitialized();
    await _localDataSource.clearAuth();
    state = const AuthStateData(state: AuthState.initial);
  }

  Future<void> checkAuth() async {
    state = state.copyWith(state: AuthState.loading);
    try {
      await _ensureInitialized();
      final userModel = await _localDataSource.getUser();
      if (userModel != null) {
        state = state.copyWith(state: AuthState.authenticated, user: userModel.toEntity());
      } else {
        state = const AuthStateData(state: AuthState.initial);
      }
    } catch (e) {
      state = const AuthStateData(state: AuthState.initial);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthStateData>((ref) {
  final localDS = ref.read(_localDataSourceProvider);
  final notifier = AuthNotifier(localDS);
  notifier.checkAuth();
  return notifier;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).state == AuthState.authenticated;
});
