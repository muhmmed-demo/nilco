import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';
import '../../core/models/user_model.dart';
import '../../core/mock/mock_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@saytara.com') {
      return MockData.salesRep;
    } else if (email == 'manager@saytara.com') {
      return MockData.manager;
    } else if (email == 'warehouse@saytara.com') {
      return MockData.warehouse;
    } else if (email == '55555' && password == '55555') {
      return MockData.salesRep; // fallback for the old 55555 requirement
    } else {
      throw Exception('Invalid username or password');
    }
  }

  @override
  Future<UserModel> register(String firstName, String lastName, String username, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return MockData.salesRep;
  }

  @override
  Future<void> verifyPhone(String phone, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> resetPassword(String newPassword, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
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
