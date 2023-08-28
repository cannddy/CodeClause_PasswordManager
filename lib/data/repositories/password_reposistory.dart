import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordRepository {
  final FlutterSecureStorage secureStorage;

  PasswordRepository(this.secureStorage);

  Future<Map<String, String>> getAllPasswords() async {
    return await secureStorage.readAll();
  }

  Future<void> savePassword(String site, String password) async {
    if (site.isNotEmpty && password.isNotEmpty) {
      await secureStorage.write(key: site, value: password);
    }
  }

  Future<void> deletePassword(String site) async {
    await secureStorage.delete(key: site);
  }
}
