import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../../constants/constants.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = Constants.baseUrl;

  var user = {};
  var userBenefits = [];
  String token = '';
  bool isLogged = false;

  AuthProvider();

  Future<void> logout() async {
    user = {};
    isLogged = false;
    var url = Uri.parse('$_baseUrl/accounts/users/logout/');
    await http.post(
      url,
      headers: {'Authorization': 'Token $token'},
    );
    notifyListeners();
  }

  Future<void> login(
    String username,
    String password, {
    String? deviceToken,
  }) async {
    var url = Uri.parse('$_baseUrl/accounts/users/login/');

    Map<String, String> body = {
      'username': username,
      'password': password,
    };
    if (deviceToken != null) {
      body['device_token'] = deviceToken;
    }
    final response = await http.post(url, body: body);

    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      token = jsonDecode(response.body)['token'];
      user = jsonDecode(response.body)['user'];
      log("$user ${user['membership']}");
      getUsedBenefitsByUser(user['id']);
      isLogged = true;
    }
    notifyListeners();
  }

  Future<void> getUsedBenefitsByUser(int id) async {
    log(token);
    var url = Uri.parse('$_baseUrl/accounts/users/$id/detail_user/');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Token $token'},
    );

    var rr = jsonDecode(response.body);
    var benefits = rr['benefits'][0]['used_benefits'];

    userBenefits = benefits.entries.map((e) {
      var map = e.value;
      map['id'] = e.key;
      return map;
    }).toList();

    notifyListeners();
  }
}
