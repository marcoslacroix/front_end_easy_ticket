import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';


class Auth with ChangeNotifier {
  late String _token = '';
  final _storage = const FlutterSecureStorage();

  Auth() {
    loadToken();
  }

  String get token => _token;

  Future<void> loadToken() async {
    var value = await _storage.read(key: 'token');
    _token = value ?? '';
    notifyListeners();
  }

  set token(String value) {
    _token = value;
    notifyListeners();
    _saveToken();
  }

  Future<void> logout() async {
    await _storage.write(key: 'token', value: '');
  }

  Future<void> _saveToken() async {
    await _storage.write(key: 'token', value: _token);
  }
}