import 'dart:convert';

import '../models/product.dart';

class ServiceResponse {
  ServiceResponse({
    required this.id,
    required this.name,
    required this.image,
    required this.products,
  });

  final int id;
  final String name;
  final String image;
  final ApiResult products;

  factory ServiceResponse.fromJson(String str) =>
      ServiceResponse.fromMap(json.decode(str));

  factory ServiceResponse.fromMap(Map<String, dynamic> json) => ServiceResponse(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        products: ApiResult.fromMap(json["products"]),
      );
}

class ApiResult {
  ApiResult({
    required this.currentPage,
    required this.pages,
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  final int currentPage;
  final int pages;
  final int count;
  final String? next;
  final String? previous;
  final List<Product> results;

  factory ApiResult.fromJson(String str) => ApiResult.fromMap(json.decode(str));

  factory ApiResult.fromMap(Map<String, dynamic> json) => ApiResult(
        currentPage: json["current_page"],
        pages: json["pages"],
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Product>.from(
          json["results"].map((x) => Product.fromMap(x)),
        ),
      );
}
