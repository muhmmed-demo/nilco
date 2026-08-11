import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> login(String email, String password) async {
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 2));
    if (email == '55555' && password == '55555') {
      return 'mock_jwt_token_123';
    } else {
      throw Exception('Invalid username or password');
    }
  }

  @override
  Future<String> register(String firstName, String lastName, String username, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email.contains('error')) {
      throw Exception('Email already exists');
    }
    return 'mock_jwt_token_new_user';
  }

  @override
  Future<void> verifyPhone(String phone, String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    if (otp != '1234') {
      throw Exception('Invalid OTP');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }
  }

  @override
  Future<void> resetPassword(String newPassword, String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    if (otp != '1234') {
      throw Exception('Invalid OTP');
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

// Provider for injecting the repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});
