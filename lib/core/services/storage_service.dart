import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save data
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read data
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete a specific key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Delete all keys (used on logout)
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
