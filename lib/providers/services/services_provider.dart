import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../models/product.dart';
import '../../models/service_response.dart';
import 'package:easy_life_club/models/location.dart';

class ServicesProvider with ChangeNotifier {
  final String _baseUrl = Constants.baseUrl;

  String? serviceType;
  String? option;

  int page = 1;
  bool loadMoreProducts = true;
  List<Product> products = [];
  String screeTitle = '';

  List services = [
    // cars
    // yachts
    // apartments
    // ...
  ];

  var otherServiceInfo = {};
  List otherServices = [
    // transportation
    // ...
  ];

  List otherServicesItems = [
    // transportation 1
    // transportation 2
    // transportation 3
    // ...
  ];

  int selectedServiceId = 0;

  // Product detail that we show in ServiceInfoScreen
  Product? selectedProduct;

  int selectedProductImageIndex = 0;

  void resetProducts() {
    products = [];
    page = 1;
    loadMoreProducts = true;
  }

  void setSelectedProductImageIndex(int index) {
    selectedProductImageIndex = index;
    notifyListeners();
  }

  void setSelectedProduct(Product product) {
    selectedProduct = product;
    notifyListeners();
  }

  Future getProductsDetailFromApi(int id, {int? location}) async {
    if (!loadMoreProducts) return;
    final pageQuery = page.toString();
    String query = location != null ? '&location=$location' : '';
    var url = Uri.parse(
      '$_baseUrl/api/v1/service/$id/detail_service/?page=$pageQuery$query&is_updated=true',
    );
    final response = await http.get(url);
    print(response.body);
    var serviceResponse = ServiceResponse.fromJson(response.body);
    products.addAll(serviceResponse.products.results);
    serviceResponse.products.next == null ? loadMoreProducts = false : page++;
    screeTitle = serviceResponse.name;
    notifyListeners();
  }

  Future<void> getSingleProductDetailFromApi(int id) async {
    var url = Uri.parse('$_baseUrl/api/v1/product/$id/');
    final response = await http.get(url);

    selectedProduct = Product.fromJson(response.body);
    notifyListeners();
  }

  Future<void> getOtherProductsDetailFromApi(int id) async {
    var url = Uri.parse('$_baseUrl/api/v1/service/others_services/');
    final response = await http.get(url);
    otherServices = jsonDecode(response.body);
    notifyListeners();
  }

  Future<void> getOtherServicesListById(int id) async {
    var url = Uri.parse(
      '$_baseUrl/api/v1/service/$id/detail_service/?is_updated=true',
    );
    final response = await http.get(url);
    final serviceResponse = jsonDecode(response.body)['products'];
    otherServicesItems = serviceResponse;
    notifyListeners();
  }

  Future<List<Location>> getLocations(int id) async {
    var url =
        Uri.parse('$_baseUrl/api/v1/service/$id/locations/?is_updated=true');
    final response = await http.get(url);
    return List<Location>.from(
      jsonDecode(response.body).map((l) => Location.fromJson(l)),
    );
  }

  // getProducts(int id) {
  //   // return <Product>[];
  //   return (services.firstWhere((element) => element.id == id).products);
  // }
}
