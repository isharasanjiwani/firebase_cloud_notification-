import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Notify',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {

  PushNotification? _notificationInfo;

  @override
  void initState() {

    FirebaseMessaging.onMessage.listen((event) {
      PushNotification notification = PushNotification(
        title: event.notification?.title,
        body: event.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
      });
    });

    checkForInitialMessage();
    super.initState();

    var initializationSettingsAndroid =
     AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS =  IOSInitializationSettings();
    var initializationSettings =  InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
  }


  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        // dataTitle: initialMessage.data['title'],
        // dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notify'),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'App for capturing Firebase Push Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16.0),
          const SizedBox(height: 16.0),
          _notificationInfo != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TITLE: ${_notificationInfo!.title}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'BODY: ${_notificationInfo!.body}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          )
              : Container(),
        ],
      ),
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    // this.dataTitle,
    // this.dataBody,
  });

  String? title;
  String? body;
  // String? dataTitle;
  // String? dataBody;
}
