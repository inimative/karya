import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:karya/notification.dart';
import 'package:karya/pages/home.dart';
import 'package:karya/pages/login.dart';
import 'package:workmanager/workmanager.dart';

import 'data/services/BackgroundService.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8099);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.settings =
          const Settings(persistenceEnabled: false);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  // Workmanager().registerPeriodicTask(
  //   "scheduleNotificationTask",
  //   "scheduleNotificationTask",
  //   frequency: const Duration(seconds: 5),
  // );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _authenticated = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: _authenticated ? const HomePage() : const LoginPage(),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _authenticated = user != null;
      });
    });
  }
}
