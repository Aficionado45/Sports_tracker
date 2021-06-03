import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sports_web/ClubListScreen.dart';
import 'package:sports_web/addUsers.dart';
import 'package:sports_web/adminLogin.dart';
import 'package:sports_web/auth_screen.dart';
import 'package:sports_web/clubsVideo.dart';
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

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
        'admin':(context) => AuthScreen(),


       //  'clubList':(context)=> ClubListScreen(),
       // 'register':(context)=> AddUsers(),
        //'clubsvideo':(context)=> ClubsVideo(),
      },
    );
  }
}
