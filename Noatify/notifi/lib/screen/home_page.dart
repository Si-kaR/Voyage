// import 'package:flutter/material.dart';
// import 'package:notifi/service/notis.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   HomePageState createState() => HomePageState(); // Added createState method
// }

// class HomePageState extends State<HomePage> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the notification plugin
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/app_icon');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           // This happens when "Send Notification" button is clicked
//           onPressed: () {
//             print("Send Notification button pressed"); // Log button press
//             Notis().showNotification(
//               title: "Title",
//               body: "Body",
//             );
//           },
//           child: const Text("Send Notification"),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:notifi/service/notis.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Notis().initNotification(); // ✅ Ensuring notifications initialize on load
  }

// Page Content is Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notify CodeSphere")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Notis().showNotification(
              title: "Title",
              body: "🎉 Notification finally works",
            );
          },
          child: const Text("Notify"),
        ),
      ),
    );
  }
}
