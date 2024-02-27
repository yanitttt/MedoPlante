
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }


  Future<void> createSession(int id) async {
    await _storage.write(key: 'id', value: id.toString());
  }

Future<String> readSession() async {
  if (await isLogged()) {
    String? id = await _storage.read(key: 'id');
    return id ?? '';
  } else {
    return '';
  }
}


Future<bool> isLogged() async {
  String? id = await _storage.read(key: 'id');
  if (id != null) {
    return true;
  } else {
    return false;
  }
}

Future<void> deleteSession() async {
  await _storage.delete(key: 'id');
}

  Future<String?> readSecureData(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }


}