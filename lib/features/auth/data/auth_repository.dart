abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<String> register(String firstName, String lastName, String username, String email, String password);
  Future<void> verifyPhone(String phone, String otp);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String newPassword, String otp);
  Future<void> logout();
}
