import 'dart:convert';

class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.priceType,
    required this.group,
    required this.features,
    required this.details,
    required this.images,
    required this.videos,
  });

  final int id;
  final String name;
  final String description;
  final String price;
  final String priceType;
  final String group;
  final Details features;
  final Details details;
  final List<ProductImage> images;
  final List<ProductVideo> videos;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        priceType: json['price_type'],
        group: json['group'],
        features: Details.fromMap(json['features']),
        details: Details.fromMap(json['details']),
        images: List<ProductImage>.from(
            json['images'].map((x) => ProductImage.fromMap(x)),
          ),
        videos: json['videos'] != null
        ? List<ProductVideo>.from(
            json['videos'].map((x) => ProductVideo.fromMap(x)),
          )
        : [],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'price_type': priceType,
        'group': group,
        'features': features.toMap(),
        'details': details.toMap(),
        'images': List<dynamic>.from(images.map((x) => x.toMap())),
        'videos': List<dynamic>.from(videos.map((x) => x.toMap())),
      };
}

class Details {
  Details({
    required this.data,
  });

  final List<ProductData> data;

  factory Details.fromJson(String str) => Details.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Details.fromMap(Map<String, dynamic> json) => Details(
        data: List<ProductData>.from(
            json['data'].map((x) => ProductData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'data': List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class ProductData {
  ProductData({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  factory ProductData.fromJson(String str) =>
      ProductData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductData.fromMap(Map<String, dynamic> json) => ProductData(
        name: json['name'],
        description: json['description'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
      };
}

class ProductImage {
  ProductImage({
    required this.id,
    required this.image,
  });

  final int id;
  final String image;

  factory ProductImage.fromJson(String str) =>
      ProductImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductImage.fromMap(Map<String, dynamic> json) => ProductImage(
        id: json['id'],
        image: json['image'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'image': image,
      };
}

class ProductVideo {
  ProductVideo({
    required this.id,
    required this.video,
  });

  final int id;
  final String video;

  factory ProductVideo.fromJson(String str) =>
      ProductVideo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductVideo.fromMap(Map<String, dynamic> json) => ProductVideo(
        id: json['id'],
        video: json['video'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'video': video,
      };

}