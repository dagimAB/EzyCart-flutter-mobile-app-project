import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Simple wrapper around FlutterSecureStorage so every screen stores
/// sensitive data (tokens, roles) in the encrypted system keystore.
class SecureStorageService {
  SecureStorageService._internal();

  static final SecureStorageService instance = SecureStorageService._internal();

  /// Using const storage so the plugin uses platform specific encryption.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Persists a value safely. We always write strings to keep the API simple.
  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a value. Returns null when the key does not exist.
  Future<String?> readSecureData(String key) async {
    return _storage.read(key: key);
  }

  /// Removes a specific key from secure storage.
  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  /// Clears only session related secrets so onboarding or cached preferences remain intact.
  Future<void> clearSessionSecrets() async {
    await _storage.delete(key: 'authToken');
    await _storage.delete(key: 'userRole');
    await _storage.delete(key: 'uid');
  }
}
