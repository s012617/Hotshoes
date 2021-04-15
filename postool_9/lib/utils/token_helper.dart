import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHelper {
  final storage = new FlutterSecureStorage();

  updateToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<String> getToken() async {
    return await storage.read(key: 'token');
  }

  removeToken() {
    storage.delete(key: 'token');
  }
}