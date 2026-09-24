import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easy_life_club/models/menu_option.dart';

class AppSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _appOpenedFirstTime = 'appOpenedFirstTime';
  static const _keyEmail = 'email';
  static const _keyPassword = 'password';
  static const _menu = 'menu';

  static Future setAppOpenedFirstTime(String value) async =>
      await _storage.write(
        key: _appOpenedFirstTime,
        value: value,
      );

  static Future<String?> getAppOpenedFirstTime() async => await _storage.read(
        key: _appOpenedFirstTime,
      );

  static Future setEmail(String email) async =>
      await _storage.write(key: _keyEmail, value: email);

  static Future<String?> getEmail() async =>
      await _storage.read(key: _keyEmail);

  static Future setMenu(List<MenuOption> menu) async {
    await _storage.write(key: _menu, value: json.encode({'_': menu}));
  }

  static Future<List<MenuOption>?> getMenu() async {
    try {      
      String? menuStr = await _storage.read(key: _menu);
      if (menuStr == null) {
        return null;
      }
      Map<String, dynamic> menuMap = json.decode(menuStr);
      return List<MenuOption>.from(
        menuMap['_'].map((x) => MenuOption.fromJson(x)),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return null;
    }
  }

  static Future setPassword(String password) async {
    await _storage.write(key: _keyPassword, value: password);
  }

  static Future<String?> getPassword() async {
    return await _storage.read(key: _keyPassword);
  }
}
