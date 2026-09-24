class OtherService {
  const OtherService({
    required this.id,
    required this.name,
    required this.images,
    this.details,
    this.description,
  });

  final int id;
  final String name;
  final List<String> images;
  final String? details;
  final String? description;

  static OtherService fromJson(Map<String, dynamic> json) {
    return OtherService(
      id: json['id'],
      name: json['name'],
      images: List<String>.from(json['images'].map((i) => i['image'])),
      details: json['description'],
      description: json['details']['description'],
    );
  }
}
