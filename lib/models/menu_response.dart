import 'dart:convert';

import 'menu_option.dart';

class MenuResponse {
  MenuResponse({
    required this.options,
  });

  final List<MenuOption> options;

  factory MenuResponse.fromJson(String str) =>
      MenuResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MenuResponse.fromMap(Map<String, dynamic> json) => MenuResponse(
        options: List<MenuOption>.from(
            json["results"].map((x) => MenuOption.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "results": List<dynamic>.from(options.map((x) => x.toMap())),
      };
}
