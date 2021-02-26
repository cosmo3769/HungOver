import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hungover_flutter_app/home.dart';
import 'package:hungover_flutter_app/notification.dart';

import 'geoLocationLocator/main.dart';

Future<void> main() async {
  //FIREBASE init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HungOver',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'productSans'),
      home: MyHomePage()
    );
  }
}
