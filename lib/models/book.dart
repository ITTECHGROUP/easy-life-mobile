import 'dart:convert';

class BookResponse {
  BookResponse({
    required this.results,
  });

  List<Book> results;

  factory BookResponse.fromJson(String str) =>
      BookResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BookResponse.fromMap(Map<String, dynamic> json) => BookResponse(
        results: List<Book>.from(json["results"].map((x) => Book.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };
}

class Book {
  Book({
    required this.id,
    required this.reservationDateStart,
    required this.reservationDateEnd,
    required this.account,
    required this.userName,
    required this.product,
    required this.productName,
  });

  int id;
  String reservationDateStart;
  String reservationDateEnd;
  int account;
  String userName;
  int product;
  String productName;

  factory Book.fromJson(String str) => Book.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Book.fromMap(Map<String, dynamic> json) => Book(
        id: json["id"],
        reservationDateStart: json["reservation_date_start"],
        reservationDateEnd: json["reservation_date_end"],
        account: json["account"],
        userName: json["user_name"],
        product: json["product"],
        productName: json["product_name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "reservation_date_start": reservationDateStart,
        "reservation_date_end": reservationDateEnd,
        "account": account,
        "user_name": userName,
        "product": product,
        "product_name": productName,
      };
}
