import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';

class MembershipProvider extends ChangeNotifier {
  final String _baseUrl = Constants.baseUrl;

  List<dynamic> memberships = [];
  var selectedMembership = {};

  MembershipProvider() {
    getMembershipsFromAPI();
  }

  setSelectedMembership(var membership) {
    selectedMembership = membership;
    notifyListeners();
  }

  getMembershipsFromAPI() async {
    var url = Uri.parse('$_baseUrl/accounts/membership/all_memberships/',
    );

    final response = await http.get(url);

    memberships = jsonDecode(response.body);
    notifyListeners();
  }

  getMembershipDetailFromAPI(int id) async {
    var url = Uri.parse('$_baseUrl/accounts/membership/$id/detail_membership/',
    );

    final response = await http.get(url);

    selectedMembership = jsonDecode(response.body);
    notifyListeners();
  }
}
