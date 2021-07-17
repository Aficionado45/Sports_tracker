import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sports_web/sharedPreference.dart';
import 'package:sports_web/videoPlayer.dart';

User loggedInUser;

class CompletedTask {
  int points;
  String Url;
  String taskName;
  String name;
  CompletedTask({this.points,this.taskName, this.Url, this.name });
}

class SecyVideo extends StatefulWidget {
  final String clubName;

  const SecyVideo({Key key, this.clubName}) : super(key: key);

  @override
  _SecyVideoState createState() => _SecyVideoState();
}

class _SecyVideoState extends State<SecyVideo> {
  final _auth = FirebaseAuth.instance;
  // FirebaseStorage _storage = FirebaseStorage.instance;
  String points;
  String pts;
  String mem;
  QuerySnapshot _querySnapshot ;
  @override
  void initState() {

    setState(() {
      getPointsThroughClubName();
    });
    super.initState();
  }

  void getPointsThroughClubName() async{
    var temp;
    var nMem;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Club_Room').doc(widget.clubName).get();
    temp = ds.get('Points');
    nMem = ds.get('no_of_member');
    print(temp);
    setState(() {
      pts = temp.toString();
      mem = nMem.toString();
    });
  }
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
              body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 80,
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, 'secylist');
                            },
                            child: const Text("Home"),
                            style: TextButton.styleFrom(
                                primary: Colors.greenAccent,
                                textStyle: TextStyle(fontSize: 16)),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                HelperFunctions.saveAdminAuthSharedPreference(false);
                                HelperFunctions.saveUserLoggedInSharedPreference(false);
                              });

                              _auth.signOut();
                              Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                            },
                            child: const Text("Logout"),
                            style: TextButton.styleFrom(
                                primary: Colors.greenAccent,
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
                        widget.clubName,
                        style: TextStyle(color: Colors.greenAccent, fontSize: 40),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              "${widget.clubName}.png"), //change to user image from firestore
                          radius: 55,
                        ),
                        backgroundColor: Colors.black,
                        radius: 60,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Score : $pts",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height:10,
                      ),
                      Text(
                        "No. of members : $mem",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 370,
                        width: MediaQuery.of(context).size.width / 2.1,
                        child: Column(
                          children: [
                            Container(
                              height: 360,
                              width: MediaQuery.of(context).size.width / 2.0,
                              child:   FutureBuilder<QuerySnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('Club_Room').doc(widget.clubName).collection("performedTask")
                                      .get(),
                                  builder: (context, snapshot) {

                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    if(!snapshot.hasData){
                                      return Text("No Data");
                                    }

                                    final List<DocumentSnapshot> documents =
                                        snapshot.data.docs;
                                    return ListView(
                                        children: documents
                                            .map((doc) => Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Card(
                                              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                                              child: ListTile(
                                                hoverColor: Colors.greenAccent,
                                                onTap : (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoApp(url: doc["videoLink"],)));
                                                },
                                                title: Center(
                                                  child: Text(
                                                    doc["Name"],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w900
                                                    ),
                                                  ),
                                                ),
                                                subtitle: Center(
                                                  child: Text(
                                                    "Points : ${doc["Points"]}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ))
                                            .toList());
                                  }),
                              decoration: BoxDecoration(
                                  color: null,
                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: null,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),


                      SizedBox(height: 30),

                      Text(
                        "Developed By: Varenya Tiwari, Karan Jain, Ayush Raj, Aayush Sachdeva",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0X90D3C48D),
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 10),
                    ],
                  )),
            )),

      ],
    );
  }

  Future<void> updatepoints(int Points, String docId){
    return FirebaseFirestore.instance.collection('Club_Room').doc(widget.clubName).collection("performedTask").doc(docId)
        .update({'Points':Points})
        .then((value) {
      print('data updated');
      setState(() {

      });
    })
        .catchError((e)=> print("failed to update : $e"));
  }
}
