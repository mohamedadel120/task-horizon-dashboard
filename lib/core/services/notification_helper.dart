// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationHelper {
  /*
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ... implementation
  */
  Future<void> init() async {
    debugPrint('NotificationHelper: Disabled (missing dependencies)');
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('NotificationHelper: Show notification $title - $body');
  }
}
