// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';


/// Example event class.
// class Event {
//   final String title;

//   const Event(this.title);

//   @override
//   String toString() => title;
// }

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// ignore: prefer_for_elements_to_map_fromiterable
// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
//   ..addAll(
//     {
//       kToday: [
//         const Event("Today's Event 1"),
//         const Event("Today's Event 2"),
//         const Event("Today's Event 3"),
//       ],
//     },
//   );

// final _kEventSource = {
//   DateTime.utc(2022, 11, 1): [
//     const Event('Event 1'),
//   ],
//   DateTime.utc(2022, 11, 2): [
//     const Event('Event 4'),
//   ],
//   DateTime.utc(2022, 11, 3): [
//     const Event('Event 7'),
//   ],
//   DateTime.utc(2022, 11, 11): [
//     const Event('Event 31'),
//   ],
//   DateTime.utc(2022, 11, 12): [
//     const Event('Event 34'),
//   ],
//   DateTime.utc(2022, 11, 13): [
//     const Event('Event 37'),
//   ],
//   DateTime.utc(2022, 11, 14): [
//     const Event('Event 40'),
//   ],
//   DateTime.utc(2022, 11, 15): [
//     const Event('Event 43'),
//   ],
//   DateTime.utc(2022, 11, 16): [
//     const Event('Event 46'),
//   ],
//   DateTime.utc(2022, 11, 17): [
//     const Event('Event 49'),
//   ],
//   DateTime.utc(2022, 11, 18): [
//     const Event('Event 52'),
//   ],
//   DateTime.utc(2022, 11, 19): [
//     const Event('Event 55'),
//   ],
//   DateTime.utc(2022, 12, 19): [
//     const Event('Event 55'),
//   ],
//   DateTime.utc(2023, 1, 1): [
//     const Event('Event 55'),
//   ],
//   DateTime.utc(2023, 6, 17): [
//     const Event('Event 55'),
//   ],
// };

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(
      first.year,
      first.month,
      first.day + index,
    ),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month, kToday.day);
