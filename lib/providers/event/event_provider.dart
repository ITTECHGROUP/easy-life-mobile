import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/constants/constants.dart';
import '/models/event.dart';

class EventProvider with ChangeNotifier {
    final String _baseUrl = Constants.baseUrl;
    List<Event> _events = [];
    List<Event>? get events => _events;

    Future<void> getEvents() async {
        final response = await http.get(Uri.parse('$_baseUrl/api/v1/event-news'));
        if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body);
            _events = data.map((item) => Event.fromJson(item)).toList();
            notifyListeners();
        }
    }
}
