import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sports_web/adminLogin.dart';
import 'package:sports_web/sharedPreference.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({Key key}) : super(key: key);

  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('sports_ball.jpg'), fit: BoxFit.fill),
          ),
        ),
        Container(
          decoration: new BoxDecoration(

              gradient: new LinearGradient(
                  colors: [
                    Color.fromRGBO(70, 75, 75, 88),
                    Color.fromRGBO(0, 0, 0, 100),
                  ],
                  stops: [
                    0.0,
                    1.0
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  tileMode: TileMode.repeated)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  height: MediaQuery.of(context).size.height/2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('errorImage.png'), fit: BoxFit.fill),
                  ),
                ),
              ),)
        )
      ],
    );
  }

}
