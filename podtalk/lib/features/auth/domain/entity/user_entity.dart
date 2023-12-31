class UserEntity {
  final String? id;
  final String username;
  final String fullname;
  final String email;
  final String password;

  UserEntity({
    this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.password,
  });
}
