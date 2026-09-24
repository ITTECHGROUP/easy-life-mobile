import 'package:easy_life_club/tools/push_notification_service.dart';

class PushNotification {
  final String title;
  final String body;
  final String type;
  final int? productId;
  final int serviceId;
  final AppStates appState;

  PushNotification({
    required this.title,
    required this.body,
    required this.type,
    this.productId,
    required this.serviceId,
    required this.appState,
  });

  factory PushNotification.fromMap(Map<String, dynamic> map) {
    return PushNotification(
      title: map['title'],
      body: map['body'],
      type: map['type'],
      productId: int.tryParse(map['product_id']),
      serviceId: int.parse(map['service_id']),
      appState: map['app_state'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'product_id': productId,
      'service_id': serviceId,
      'app_state': appState,
    };
  }
}
