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
  final _auth = FirebaseAuth.instance;
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
  LinkedHashMap sortedMap;
  var sortedKeys;
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

  Future<void> points() async {
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
      var sortedKeys = finalscore.keys.toList(growable: false)
        ..sort((k1, k2) => finalscore[k2].compareTo(finalscore[k1]));

      Map<String, dynamic> sortedMap = new Map<String, dynamic>.fromIterable(
          sortedKeys,
          key: (k) => k,
          value: (k) => finalscore[k]);

      finalscore = sortedMap;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            body: SingleChildScrollView(
              child: Column(children: [
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
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
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
                FutureBuilder(
                    future: points(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done)
                        return Text("Loading",
                            style: TextStyle(
                                color: Color(0XFFD3C48D), fontSize: 10));
                      return Container(
                        height: 550,
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: new ListView.builder(
                          itemCount: finalscore.length,
                          itemBuilder: (BuildContext context, int index) {
                            index++;
                            String key = finalscore.keys.elementAt(index - 1);

                            return ListTile(
                              leading: Text("$index",
                                  style: TextStyle(
                                      color: Color(0XFFD3C48D), fontSize: 20)),
                              title: new Text("$key",
                                  style: TextStyle(
                                      color: Color(0XFFD3C48D), fontSize: 20)),
                              trailing: new Text(
                                "${finalscore[key]}",
                                style: TextStyle(
                                    color: Color(0XFFD3C48D), fontSize: 20),
                              ),
                            );
                          },
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xFF1C1F1E),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      );
                    }),
                SizedBox(height: 10),
              ]),
            )));
  }
}
