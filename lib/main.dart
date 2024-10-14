import 'package:flutter/material.dart';
import 'package:fur_pass/Screens/EventDetail.dart';
import 'package:fur_pass/Screens/EventsPage.dart';
import 'package:fur_pass/Screens/MainPage.dart';

import 'Global.dart';

void main() => Global.init().then((e) => runApp(const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UwU',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        "/" : (context) => const MainPage(),
        "/events": (context) => const EventsPage(),
        "/eventDetail": (context) => const EventDetail(),
      },
    );
  }
}

