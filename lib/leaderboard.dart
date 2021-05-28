import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User loggedInUser;

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<SplayTreeMap<String, dynamic>> aquatics_points() async {
    Map<String, dynamic> finalscore = {
      "Squash": 0,
      "Athletics": 0,
      "Table Tennis": 0,
      "Basketball": 0,
      "Badminton": 0,
      "Cricket": 0,
      "Aquatics": 0,
      "Hockey": 0,
      "Tennis": 0,
      "Football": 0,
      "Volleyball": 0,
      "Weightlifting": 0
    };
    var point = await firestoreInstance
        .collection("Points_table")
        .where("Aquatics", isGreaterThan: -1)
        .get()
        .then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((result) {
        Map<String, dynamic> current = result.data();
        for (var key1 in current.keys) {
          for (var key2 in finalscore.keys) {
            if (key1 == key2) {
              finalscore[key2] = finalscore[key2] + current[key1];
            }
          }
        }
      });
      var sortedByValue = new SplayTreeMap<String, dynamic>.from(finalscore,
          (key1, key2) => finalscore[key1].compareTo(finalscore[key2]));
      print(sortedByValue);
      return sortedByValue;
    });
  }

  Widget build(BuildContext context) {
    Future<SplayTreeMap<String, dynamic>> points = aquatics_points();
    return Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromRGBO(0, 0, 0, 83),
                  Color.fromRGBO(0, 0, 0, 41),
                ],
                stops: [0.0, 1.0],
                tileMode: TileMode.repeated)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(children: [
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 80,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'home');
                  },
                  child: const Text("HOME"),
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      textStyle: TextStyle(fontSize: 16)),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'leader');
                  },
                  child: const Text("LEADERBOARDS"),
                  style: TextButton.styleFrom(
                      primary: Color(0XFFD3C48D),
                      textStyle: TextStyle(fontSize: 16)),
                ),
                SizedBox(
                  width: 30,
                ),
                TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, 'login');
                  },
                  child: const Text("LOGOUT"),
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      textStyle: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "LEADERBOARDS",
              style: TextStyle(color: Color(0XFFD3C48D), fontSize: 40),
            ),
            Container(
              height: 550,
              width: MediaQuery.of(context).size.width / 1.1,
              decoration: BoxDecoration(
                  color: Color(0xFF1C1F1E),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ]),
        ));
  }
}

// Store points from each task of each club in a map then perform operation to
// add up points for each particualr club and sort accordingly then using list view
// print them on the screen.
