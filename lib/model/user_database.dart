import 'app_user.dart';

class UserDatabase {
  static final List<AppUser> _registeredUsers = [
    // Contoh:
    // AppUser(username: "testuser", password: "password123", namaLengkap: "Test User", email: "test@example.com", noHandphone: "081234567890"),
  ];
  static AppUser? currentUser;

  static void loginUser(AppUser user) {
    currentUser = user;
  }

  static void logoutUser() {
    currentUser = null;
  }

  static bool addUser(AppUser user) {
    if (_registeredUsers.any(
      (existingUser) => existingUser.username == user.username,
    )) {
      print("Error: Username ${user.username} sudah terdaftar.");
      return false;
    }
    if (_registeredUsers.any(
      (existingUser) => existingUser.email == user.email,
    )) {
      print("Error: Email ${user.email} sudah terdaftar.");
      return false; // Tambahkan pengecekan email jika email harus unik
    }
    _registeredUsers.add(user);
    print("User berhasil ditambahkan: ${user.username} (${user.namaLengkap})");
    return true;
  }

  static AppUser? findUser(String username, String password) {
    try {
      return _registeredUsers.firstWhere(
        (user) => user.username == username && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // --- FUNGSI BARU UNTUK FORGET PASSWORD ---
  static AppUser? findUserByEmailAndPhone(String email, String phone) {
    try {
      return _registeredUsers.firstWhere(
        (user) => user.email == email && user.noHandphone == phone,
      );
    } catch (e) {
      return null; // Tidak ditemukan pengguna dengan email dan no HP tersebut
    }
  }

  static bool updateUserPassword(String username, String newPassword) {
    try {
      AppUser userToUpdate = _registeredUsers.firstWhere(
        (user) => user.username == username,
      );
      // Karena password di model AppUser sekarang non-final, kita bisa langsung ubah
      userToUpdate.password = newPassword;
      print(
        "Password untuk user ${userToUpdate.username} berhasil diperbarui.",
      );
      return true;
    } catch (e) {
      print("Error: Gagal memperbarui password untuk username $username.");
      return false;
    }
  }

  // --- AKHIR FUNGSI BARU ---
}
