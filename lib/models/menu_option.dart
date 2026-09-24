import 'dart:convert';

class MenuOption {
  MenuOption({
    required this.id,
    required this.name,
    required this.image,
    required this.route,
  });

  final int id;
  final String name;
  final String image;
  final String route;

  factory MenuOption.fromJson(String str) =>
      MenuOption.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MenuOption.fromMap(Map<String, dynamic> json) => MenuOption(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        route: json["route"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
        "route": route,
      };
}
