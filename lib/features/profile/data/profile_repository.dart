import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.avatarUrl,
  });
}

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<UserProfile> getProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserProfile(
      id: '1',
      firstName: 'Ahmed',
      lastName: 'Ali',
      email: 'ahmed.ali@nilco.com',
      role: 'Sales Representative',
      avatarUrl: 'https://via.placeholder.com/150',
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

final profileProvider = FutureProvider<UserProfile>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile();
});
