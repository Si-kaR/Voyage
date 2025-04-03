// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class Notis {
//   final notificationsplugin = FlutterLocalNotificationsPlugin();
//   final bool _isInitialized = false;

//   // ignore: unused_element, recursive_getters
//   bool get isInitialized => _isInitialized;

//   // INITIALIZATION
//   Future<void> initNotification() async {
//     if (isInitialized) return; //prevent re-initialization

//     // Prepare android init settings
//     const initSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // Prepare ios init settings
//     const initSettingsIOS = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true);

//     // init settings for both
//     const initSettings = InitializationSettings(
//         android: initSettingsAndroid, iOS: initSettingsIOS);

//     // finally initialise the plugin
//     await notificationsplugin.initialize(initSettings);
//   }

//   // NOTIFICATION SET UP
//   NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//           'daily_channel_id', 'Daily Notifications',
//           channelDescription: 'Daily Channel Descriptions',
//           importance: Importance.max,
//           priority: Priority.high),
//       iOS: DarwinNotificationDetails(),
//     );
//   }

//   //SHOW NOTIFICATION
//   Future<void> showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//   }) async {
//     return notificationsplugin.show(
//         id, title, body, const NotificationDetails());
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class Notis {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // INITIALIZATION
  Future<void> initNotification() async {
    if (isInitialized) return; // Prevent re-initialization

    // Request notification permissions (especially for Android 13+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Android init settings
    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Init settings for both platforms
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    // Initialize plugin
    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true; // ✅ Mark initialization as complete
  }

  // NOTIFICATION SETUP
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Channel Descriptions',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // SHOW NOTIFICATION
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!isInitialized) await initNotification(); // Ensure it's initialized
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(), // ✅ Use the defined notification details
    );
  }
}
