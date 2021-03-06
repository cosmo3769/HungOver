import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hungover_flutter_app/home.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class NotifyAlert extends StatefulWidget {
  var currentUser;


  NotifyAlert(this.currentUser);

  @override
  State<StatefulWidget> createState() => NotifyAlertState(this.currentUser);
}

class NotifyAlertState extends State<NotifyAlert> {
  var currentUser;

  NotifyAlertState(this.currentUser);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/launcher_icon');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android,iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(this.currentUser);
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max,enableVibration: true,playSound: true);
    var iOS = new IOSNotificationDetails(sound: "sound.mp3");
    var platform = new NotificationDetails(android,iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Event in your Area.', 'Open HungOver app to view more.', platform,
        payload: 'Near-by event found. Open HungOver app to view more details.');
  }
}
