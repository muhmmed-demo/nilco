import '../../../../core/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String firstName, String lastName, String username, String email, String password);
  Future<void> verifyPhone(String phone, String otp);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String newPassword, String otp);
  Future<void> logout();
}
