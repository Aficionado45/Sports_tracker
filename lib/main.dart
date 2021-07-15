import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sports_web/ClubListScreen.dart';
import 'package:sports_web/addUsers.dart';
import 'package:sports_web/adminLogin.dart';
import 'package:sports_web/auth_screen.dart';
import 'package:sports_web/home_screen.dart';
import 'package:sports_web/reset.dart';
import 'package:sports_web/sharedPreference.dart';
import 'login_screen.dart';
import 'leaderboard.dart';
import 'reset.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Future.delayed(Duration(seconds: 1));
  await firebase_core.Firebase.initializeApp();
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
  bool isLoggedIn =false;
  bool isUserAdmin = false;
  getLoggedInState()async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if(value != null){
        setState(() {
          isLoggedIn = value;
        });
      }

    });
    await HelperFunctions.getAdminAuthSharedPreference().then((val) {
      if(val != null){
        setState(() {
          isUserAdmin =val;
        });
      }

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();

    super.initState();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: "IIT Fitness Tracker",
       initialRoute: isLoggedIn? isUserAdmin? 'clubList':'home': 'login',
      routes: {
        //Add all the page navigation refrences here to navigate across screens.
        'login': (context) => Login(),
        'home': (context) => Home(),
        'leader': (context) => Leaderboard(),
        'reset': (context) => ResetScreen(),
        'auth':(context) => AuthScreen(),
        'admin':(context) => AdminLogin(),

        'clubList':(context)=>ClubListScreen(),
       'register':(context)=>AddUsers(),
        // 'clubsvideo':(context)=> ClubsVideo(clubName: "Aquatics",),
      },
    );
  }
}
