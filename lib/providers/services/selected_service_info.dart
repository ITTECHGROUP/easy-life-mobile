import 'package:flutter/material.dart';

class SelectedServiceInfo with ChangeNotifier {
  String _serviceTitle = "Nombre del Servicio";
  String _serviceDescription = "Descripción del Servicio";
  int _price = 0;
  int _topSpeed = 0;
  double _accelerationTime = 0.0;
  int _hp = 0;
  double _capacityLiters = 0.0;
  double _capacityCc = 0.0;
  String _motorType = "None";
  String _tag = "No tag";
  String _img = "no image";

  String get serviceTitle => _serviceTitle;
  String get serviceDescription => _serviceDescription;
  int get price => _price;
  int get topSpeed => _topSpeed;
  double get accelerationTime => _accelerationTime;
  double get capacityLiters => _capacityLiters;
  double get capacityCc => _capacityCc;
  String get motorType => _motorType;
  int get hp => _hp;
  String get tag => _tag;
  String get img => _img;

  set serviceTitle(String serviceTitle) {
    _serviceTitle = serviceTitle;

    notifyListeners();
  }

  set serviceDescription(String serviceDescription) {
    _serviceDescription = serviceDescription;

    notifyListeners();
  }

  set price(int price) {
    _price = price;

    notifyListeners();
  }

  set topSpeed(int topSpeed) {
    _topSpeed = topSpeed;
    notifyListeners();
  }

  set accelerationTime(double accelerationTime) {
    _accelerationTime = accelerationTime;
    notifyListeners();
  }

  set capacityLiters(double capacityLiters) {
    _capacityLiters = capacityLiters;
    notifyListeners();
  }

  set capacityCc(double capacityCc) {
    _capacityCc = capacityCc;
    notifyListeners();
  }

  set motorType(String motorType) {
    _motorType = motorType;
    notifyListeners();
  }

  set hp(int value) {
    _hp = value;
    notifyListeners();
  }

  set tag(String value) {
    _tag = value;
    notifyListeners();
  }

  set img(String value) {
    _img = value;
    notifyListeners();
  }
}
