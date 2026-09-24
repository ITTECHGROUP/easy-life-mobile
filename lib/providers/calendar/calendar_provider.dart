import 'dart:collection';
import 'dart:io';
import 'package:easy_life_club/constants/constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/book.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarProvider extends ChangeNotifier {
  final String _baseUrl = Constants.baseUrl;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _firstDay;
  bool _acceptedTermsAndConditions = false;
  int calendarAmount = 3;
  bool isLoadingMoreCalendars = false;

  DateTime? get firstDay => _firstDay;
  DateTime? get rangeStart => _rangeStart;
  DateTime? get rangeEnd => _rangeEnd;
  bool get acceptedTermsAndConditions => _acceptedTermsAndConditions;

  LinkedHashMap<DateTime, List<Reservation>>? kEvents;

  /* List of reservations from API
    {
      "id": 19,
      "reservation_date_start": "2022-11-17",
      "reservation_date_end": "2022-11-20",
      "account": 17,
      "user_name": "Andrea",
      "product": 1,
      "product_name": "Porchealsd"
    },
  */
  List<Book> reservationData = [];

  // final _kEventSource = {
  //   DateTime.utc(2022, 11, 1): [
  //     const Event('Event 1'),
  //   ],
  // };

  _generateEventSource() {
    Map<DateTime, List<Reservation>> kEventSource = {};
    for (var i = 0; i < reservationData.length; i++) {
      var reservation = reservationData[i];
      final sd = reservation.reservationDateStart.split("-");
      final ed = reservation.reservationDateEnd.split("-");
      var startDate = DateTime.utc(
        int.parse(sd[0]),
        int.parse(sd[1]),
        int.parse(sd[2]),
      );
      var endDate = DateTime.utc(
        int.parse(ed[0]),
        int.parse(ed[1]),
        int.parse(ed[2]),
      );
      var difference = endDate.difference(startDate).inDays;
      for (var j = 0; j <= difference; j++) {
        var date = startDate.add(Duration(days: j));
        if (kEventSource.containsKey(date)) {
          kEventSource[date]!.add(
            Reservation(reservation.productName),
          );
        } else {
          kEventSource[date] = [
            Reservation(
              reservation.productName,
            )
          ];
        }
      }
    }
    return kEventSource;
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  getEvents(Map<DateTime, List<Reservation>> eventSource) {
    final kEvents = LinkedHashMap<DateTime, List<Reservation>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventSource);

    return kEvents;
  }

  /// List all reservations by [productId] from API.
  getReservationDataById(int productId) async {
    var url = Uri.parse('$_baseUrl/api/v1/reservation/$productId/reservations_by_product/');

    final response = await http.get(url,headers: {
        'Authorization': 'Token 434947ab0ae9e3253794b1c3f4bbb57005beaf38',
        'Content-Type': 'application/json'
      });

    if (response.statusCode == 200) {
      final booResponse = BookResponse.fromJson(
        '{"results": ${response.body}}',
      );
      reservationData = booResponse.results;
      notifyListeners();
    } else {}
  }

  set firstDay(DateTime? value) {
    _firstDay = value;
    notifyListeners();
  }

  set rangeStart(DateTime? value) {
    _rangeStart = value;
    notifyListeners();
  }

  set rangeEnd(DateTime? value) {
    _rangeEnd = value;
    notifyListeners();
  }

  updateRangeStart(DateTime start) async {
    _rangeStart = start;
    notifyListeners();
  }

  updateRangeEnd(DateTime end) async {
    _rangeEnd = end;
    notifyListeners();
  }

  loadingMoreCalendars(bool value) {
    isLoadingMoreCalendars = value;
    notifyListeners();
  }

  changeTermsAndConditionsStatus(bool value) {
    _acceptedTermsAndConditions = value;
    notifyListeners();
  }

  updateCalendarAmout(int amount) {
    calendarAmount = amount;
    isLoadingMoreCalendars = false;
    notifyListeners();
  }

  CalendarProvider();

  // This update the calendar reservation events,
  // gereating a new event source from the API data.
  // Then, the new event source is used to generate a new reservation list.
  updateCalendarReservationData() {
    var eventSource = _generateEventSource();
    kEvents = getEvents(eventSource);
    notifyListeners();
  }

  resetRange() async {
    _rangeStart = null;
    _rangeEnd = null;
    notifyListeners();
  }

  setRange(start, end) async {
    _rangeStart = start;
    _rangeEnd = end;
    notifyListeners();
  }

  sendWhatsAppMessageWithDate(
    String productName,
    String startDate,
    String endDate,
  ) async {
    var phoneNumber = "+17862961703";
    var message = """Thank you for trusting Easy Life Club!
    
The $productName will soon be yours from $startDate to $endDate. 
In order to complete the experience, we have to conclude with the payment stage.""";

    if (Platform.isAndroid) {
      var whatsappURLAndroid =
          "whatsapp://send?phone=$phoneNumber&text=$message";
      await launchUrl(Uri.parse(whatsappURLAndroid));
    } else {
      var whatsappURL = "https://wa.me/$phoneNumber?text=$message";
      await launchUrl(Uri.parse(whatsappURL));
    }
  }
}

class Reservation {
  final String title;

  const Reservation(this.title);

  @override
  String toString() => title;
}
