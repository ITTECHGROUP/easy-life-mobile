import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/menu_option.dart';
import '../models/menu_response.dart';
import 'package:easy_life_club/utils/app_secure_storage.dart';

class MenuProvider with ChangeNotifier {
  final String _baseUrl = Constants.baseUrl;

  List<MenuOption>? menu;

  Future<String?> getMenuFromAPI() async {
    print('getMenuFromAPI()');
    var url = Uri.parse('$_baseUrl/api/v2/service/menu/');

    try {
      final response = await http.get(url);

      final menuResponse =
          MenuResponse.fromJson('{"results": ${response.body}}');
      menu = menuResponse.options;
      await AppSecureStorage.setMenu(menu!);
      notifyListeners();
      return null;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return 'An error occurred, please try again later.';
    }
  }
}
