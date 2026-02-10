// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:task_dashboard/core/services/notification_helper.dart';
// import 'package:task_dashboard/core/services/notification_navigation_handler.dart';
// import 'package:task_dashboard/features/notifications/data/models/notification_data_model.dart';
// import 'package:task_dashboard/firebase_options.dart';

class FirebaseMessagingService {
  /*
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _notificationHelper = NotificationHelper();

  Future<void> initNotifications() async {
    try {
      if (kIsWeb) {
        // Web configuration...
      }

      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      // ... rest of implementation
    } catch (e) {
      debugPrint('Error initializing Firebase Messaging: $e');
    }
  }
  */
  Future<void> initNotifications() async {
    debugPrint(
      'FirebaseMessagingService: Notifications disabled (missing dependencies)',
    );
  }
}
