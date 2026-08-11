import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_repository_impl.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final FlutterSecureStorage _storage;

  AuthController(this._repository, this._storage) : super(const AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = const AuthLoading();
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        state = AuthAuthenticated(token);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (e) {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final token = await _repository.login(email, password);
      await _storage.write(key: 'auth_token', value: token);
      state = AuthAuthenticated(token);
    } catch (e) {
      state = AuthError(e.toString());
      // Revert to unauthenticated after error is consumed by UI, or let UI handle the error state.
    }
  }

  Future<void> register(String firstName, String lastName, String username, String email, String password) async {
    state = const AuthLoading();
    try {
      final token = await _repository.register(firstName, lastName, username, email, password);
      await _storage.write(key: 'auth_token', value: token);
      state = AuthAuthenticated(token);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> verifyPhone(String phone, String code) async {
    await _repository.verifyPhone(phone, code);
  }

  Future<void> forgotPassword(String email) async {
    await _repository.forgotPassword(email);
  }

  Future<void> resetPassword(String email, String code, String newPassword) async {
    await _repository.resetPassword(newPassword, code);
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await _repository.logout();
    await _storage.delete(key: 'auth_token');
    state = const AuthUnauthenticated();
  }
}

// Providers
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthController(repository, storage);
});
