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
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: (map['type'] ?? '').toString(),
      productId: int.tryParse((map['product_id'] ?? '').toString()),
      // Pushes sent from the Firebase console carry no service; 0 means "just open the app".
      serviceId: int.tryParse((map['service_id'] ?? '').toString()) ?? 0,
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
