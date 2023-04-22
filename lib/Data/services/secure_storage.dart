import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage? _instance;

  factory SecureStorage() =>
      _instance ??= SecureStorage._(const FlutterSecureStorage());

  SecureStorage._(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'TOKEN';
  static const _phoneKey = 'PHONE';
  static const _localeKey = 'LANG';
  // static int coins = 10;
  Future<void> persistPhoneAndToken(String phone, String token) async {
    await _storage.write(key: _phoneKey, value: phone);
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> writeToLocalStorage(String keyValue, String value) async {
    // String? previousKey = _storage.read(key: key);
    // if (_storage.read(key: key)) {}
    await _storage.write(key: keyValue, value: value);
  }

  Future<String> readFromLocalStorage(String key) async {
    return await _storage.read(key: key) ?? "";
  }

  Future<void> persistLocale(String locale) async {
    await _storage.write(key: _localeKey, value: locale);
  }

  Future<bool> hasToken() async {
    var value = await _storage.read(key: "LOGIN_STATUS");
    return value != null;
  }

  Future<bool> hasPhone() async {
    var value = _storage.read(key: _phoneKey);
    return value != null;
  }

  Future<bool> hasLocale() async {
    var value = _storage.read(key: _localeKey);
    return value != null;
  }

  Future<void> deleteToken() async {
    return _storage.delete(key: _tokenKey);
  }

  Future<void> deletePhone() async {
    return _storage.delete(key: _phoneKey);
  }

  Future<void> deleteLocale() async {
    return _storage.delete(key: _localeKey);
  }

  Future<String?> getPhone() async {
    return _storage.read(key: _phoneKey);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<int> getCoins() async {
    return int.parse(await _storage.read(key: "COINS") ?? 0.toString());
  }

  Future<void> addCoins() async {
    int coins = int.parse(await _storage.read(key: "COINS") ?? 0.toString());
    //  int.parse(await _storage.read(key: "COINS") ?? 0.toString());
    await _storage.write(key: "COINS", value: (coins + 1).toString());
  }

  Future<void> setCoinsToZero() async {
    // int coins = int.parse(await _storage.read(key: "COINS") ?? 0.toString());
    //  int.parse(await _storage.read(key: "COINS") ?? 0.toString());
    await _storage.write(key: "COINS", value: (0).toString());
  }

  Future<String?> getLocale() async {
    return _storage.read(key: _localeKey);
  }

  Future<void> deleteAll() async {
    return _storage.deleteAll();
  }

  Future<String?> getFirstName() async {
    return _storage.read(key: "FIRST_NAME");
  }

  Future<String?> getLastName() async {
    return _storage.read(key: "LAST_NAME");
  }

  Future<String?> getNameShowStatus() async {
    return _storage.read(key: "SHOW_NAME");
  }

  Future<String?> getProfileShowStatus() async {
    return _storage.read(key: "SHOW_PROFILE");
  }

  Future<void> deleteProfileShowStatus() async {
    return _storage.delete(key: "SHOW_PROFILE");
  }

  Future<void> deleteNameShowStatus() async {
    return _storage.delete(key: "SHOW_NAME");
  }

  Future<String?> getPhotoLocation() async {
    return _storage.read(key: "PHOTO_URL");
  }
}
