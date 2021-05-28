import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sports_web/home_screen.dart';
import 'package:sports_web/reset.dart';
import 'login_screen.dart';
import 'leaderboard.dart';
import 'reset.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login',
      routes: {
        //Add all the page navigation refrences here to navigate across screens.
        'login': (context) => Login(),
        'home': (context) => Home(),
        'leader': (context) => Leaderboard(),
        'reset': (context) => ResetScreen(),
        //'admin:(context) => AdminScreen(),
      },
    );
  }
}
