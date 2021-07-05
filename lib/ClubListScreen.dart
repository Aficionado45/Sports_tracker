import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sports_web/clubsVideo.dart';
import 'package:sports_web/errorPage.dart';
import 'package:sports_web/sharedPreference.dart';

User loggedInUser;

class ClubListScreen extends StatefulWidget {
  const ClubListScreen({Key key}) : super(key: key);

  @override
  _ClubListScreenState createState() => _ClubListScreenState();
}

class _ClubListScreenState extends State<ClubListScreen> {

  @override
  bool isUserAdmin =false;
  bool isLoggedIn = false;
  final _auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection("users");
  String name, club, uid;

  getUserLog()async{
    await HelperFunctions.getAdminAuthSharedPreference().then((value) {
      if(value != null){
        setState(() {
          isUserAdmin =value;
        });
      }
    });
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if(value != null){
        setState(() {
          isLoggedIn = value;
        });
      }
    });
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    getCurrentUser();
    getUserLog();
  }


  Widget build(BuildContext context) {
    if(isLoggedIn && isUserAdmin){
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
                                Navigator.pushNamed(context, 'clubList');
                              },
                              child: const Text("HOME"),
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  textStyle: TextStyle(fontSize: 16)),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'register');
                              },
                              child: const Text("Add Users"),
                              style: TextButton.styleFrom(
                                  primary: Color(0XFFD3C48D),
                                  textStyle: TextStyle(fontSize: 16)),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  HelperFunctions.saveAdminAuthSharedPreference(false);
                                  HelperFunctions.saveUserLoggedInSharedPreference(false);
                                });

                                _auth.signOut();
                                Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
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
                          "Welcome",
                          style: TextStyle(color: Color(0xFFF3EFEF), fontSize: 40),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                "logo_sportsboard.png"), //change to user image from firestore
                            radius: 55,
                          ),
                          backgroundColor: Colors.black,
                          radius: 60,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "You Logged In As Admin",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0XFFD3C48D),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 370,
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.4,
                                height: 50,
                                margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
                                child: Center(
                                  child: Text(

                                    "Sports Club List",
                                    style: TextStyle(
                                      color: Color(0XFF585858),
                                      fontSize: 16,

                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              Container(
                                height: 260,
                                width: MediaQuery.of(context).size.width / 1.6,
                                child:  FutureBuilder<QuerySnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('Club_Room')
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
                                              .map((doc) => Card(

                                              child: ListTile(
                                                hoverColor: Colors.red,
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ClubsVideo(clubName: doc['Club_Name'],)));
                                                },
                                                title: Center(
                                                  child: Text(
                                                    doc['Club_Name'],
                                                    style: TextStyle(
                                                      color: Color(0XFF585858),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),

                                              )))
                                              .toList());
                                    }),
                                decoration: BoxDecoration(
                                    color: Color(0xF771C1F1E),
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xFF1C1F1E),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                        SizedBox(height: 10),
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
              ))
        ],
      );
    }
    else{
      return NotFoundPage();
    }
  }
}

