import 'file:///C:/Users/user/Desktop/Flutter%20Projects/eat_now/lib/initial_pages/onboarding.dart';
import 'file:///C:/Users/user/Desktop/Flutter%20Projects/eat_now/lib/initial_pages/verify_email.dart';
import 'package:eat_now/services/RxServices.dart';
import 'package:eat_now/services/auxilliary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'initial_pages/AuthListener.dart';
import 'services/MyServices.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MyService()),
  ], child: MyApp()));
  GetIt.I.registerSingleton<RxServices>(RxServices());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat Now',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool isSplash = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5500), () {
      setState(() {
        isSplash = !isSplash;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: aux2,
        body: isSplash
            ? Container(
                color: aux2,
                child: Center(
                  child: Image.asset('assets/logo1.jpeg'),
                ),
              )
            : AuthListener());
  }
}
