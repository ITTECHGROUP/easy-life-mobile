class Location {
  const Location(this.id, this.name, this.image);

  final int id;
  final String name;
  final String? image;

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(json['id'], json['name'], json['image']);
}
