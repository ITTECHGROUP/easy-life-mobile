class Event {
  bool active;
  String title;
  String image;
  String description;

  Event({
    required this.active,
    required this.title,
    required this.image,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    active: json['active'],
    title: json['title'],
    image: json['image'],
    description: json['description'],
  );
}
