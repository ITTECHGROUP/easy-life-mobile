import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';
import '../../models/product.dart';
import '../../models/service_response.dart';
import 'package:easy_life_club/models/location.dart';
import 'package:easy_life_club/models/vehicle_model.dart';

class ServicesProvider with ChangeNotifier {
  final String _baseUrl = Constants.baseUrl;

  String? serviceType;
  String? option;

  int page = 1;
  bool loadMoreProducts = true;
  List<Product> products = [];
  List<dynamic> firestoreVehicles = [];
  Vehicle? selectedVehicle;
  String screeTitle = '';

  List services = [];

  var otherServiceInfo = {};
  List otherServices = [];

  List otherServicesItems = [];

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

  void setSelectedVehicle(Vehicle vehicle) {
    selectedVehicle = vehicle;
    notifyListeners();
  }

  Future<void> fetchVehiclesFromFirebase() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('vehicles').get();
      // Same visibility rule as the website: "hidden" cars are drafts managed from the panel.
      firestoreVehicles = snapshot.docs
          .where((doc) => (doc.data()['status'] ?? '').toString() != 'hidden')
          .map((doc) => Vehicle.fromDoc(doc))
          .toList()
        ..sort((a, b) => (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0));
    } catch (e) {
      print('Error fetching vehicles from Firestore: $e');
      firestoreVehicles = [];
    }
    notifyListeners();
  }

  Future getProductsDetailFromApi(int id, {int? location}) async {
    if (!loadMoreProducts) return;
    final pageQuery = page.toString();
    String query = (location != null && location > 0) ? '&location=$location' : '';
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
    final decoded = jsonDecode(response.body);

    if (decoded != null && decoded['products'] != null) {
      final productsData = decoded['products'];
      if (productsData is Map && productsData.containsKey('results')) {
        otherServicesItems = productsData['results'] as List? ?? [];
      } else if (productsData is List) {
        otherServicesItems = productsData;
      } else {
        otherServicesItems = [];
      }
    } else {
      otherServicesItems = [];
    }
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
}