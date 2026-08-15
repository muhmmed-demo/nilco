import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../features/auth/data/auth_repository.dart';
import '../../../core/models/user_model.dart';
import '../../sources/remote/supabase_auth_source.dart';
import '../../sources/local/hive_auth_cache.dart';

class SupabaseAuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthSource _remoteSource;
  final HiveAuthCache _localCache;

  SupabaseAuthRepositoryImpl(this._remoteSource, this._localCache);

  Future<bool> _hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    if (await _hasInternet()) {
      final response = await _remoteSource.signIn(email, password);
      if (response.user != null) {
        // Here we would typically fetch the full user profile from a 'users' table
        // For simplicity, we construct a UserModel from the auth response
        final user = UserModel(
          id: response.user!.id,
          firstName: 'User', // Mocked, should come from DB
          lastName: '',
          username: email.split('@')[0],
          email: email,
          phone: '',
          role: UserRole.salesRep, // Mocked, should come from DB
          token: response.session?.accessToken ?? '',
          companyName: 'نيلكو',
        );
        
        // Cache it
        await _localCache.cacheUser({
          'id': user.id,
          'email': user.email,
          'role': user.role.toString(),
          'token': user.token,
        });
        
        return user;
      }
      throw Exception('Login failed');
    } else {
      // Offline fallback
      final cached = await _localCache.getCachedUser();
      if (cached != null && cached['email'] == email) {
        return UserModel(
          id: cached['id'],
          firstName: 'Offline',
          lastName: 'User',
          username: 'offline',
          email: cached['email'],
          phone: '',
          role: cached['role'] == 'UserRole.manager' ? UserRole.manager : UserRole.salesRep,
          token: cached['token'],
          companyName: 'نيلكو',
        );
      }
      throw Exception('No internet and no cached credentials found.');
    }
  }

  @override
  Future<UserModel> register(String firstName, String lastName, String username, String email, String password) async {
    throw UnimplementedError('Registration is handled via Admin panel in this ERP');
  }

  @override
  Future<void> verifyPhone(String phone, String otp) async {
    // Implement phone verification logic here
  }

  @override
  Future<void> forgotPassword(String email) async {
    // Implement forgot password logic here
  }

  @override
  Future<void> resetPassword(String newPassword, String otp) async {
    // Implement reset password logic here
  }

  @override
  Future<void> logout() async {
    await _remoteSource.signOut();
    await _localCache.clearAuth();
  }
}
