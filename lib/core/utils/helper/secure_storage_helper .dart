import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: file_names


class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();

  Future<void> saveData({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    // ignore: empty_catches
    } catch (e) {}
  }

  Future<String?> getData({required String key}) async {
    try {
      final value = await _storage.read(key: key);
      return value;
    } catch (e) {
      return null;
    }
  }

  Future<void> removeData({required String key}) async {
    try {
      await _storage.delete(key: key);
    // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> clearData() async {
    try {
      await _storage.deleteAll();
    // ignore: empty_catches
    } catch (e) {}
  }
}
