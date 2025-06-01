class AppUser {
  final String username;
  String password;
  final String? namaLengkap;
  final String? email;
  final String? noHandphone;

  AppUser({
    required this.username,
    required this.password,
    this.namaLengkap,
    this.email,
    this.noHandphone,
  });
}
