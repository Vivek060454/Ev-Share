import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<void> initialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.announcement == AuthorizationStatus.authorized) {
      print("Notification Initialized");
    }
  }
}
