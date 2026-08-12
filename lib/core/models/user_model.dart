enum UserRole {
  salesRep,
  manager,
  warehouse,
}

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final String token;
  final String companyName;
  final String? branchId;
  final String? regionId;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    required this.token,
    required this.companyName,
    this.branchId,
    this.regionId,
  });
}
