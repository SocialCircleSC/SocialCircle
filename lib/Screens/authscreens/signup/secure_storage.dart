import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  // Save Password
  static Future<void> savePassword(String password) async {
    await _storage.write(key: 'user_password', value: password);
  }

  // Retrieve Password
  static Future<String?> getPassword() async {
    return await _storage.read(key: 'user_password');
  }

  // Delete Password
  static Future<void> deletePassword() async {
    await _storage.delete(key: 'user_password');
  }
}