import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sports_web/errorPage.dart';
import 'package:sports_web/sharedPreference.dart';
import 'package:sports_web/SecyVideo.dart';

User loggedInUser;

class SecyListScreen extends StatefulWidget {
  const SecyListScreen({Key key}) : super(key: key);

  @override
  _SecyListScreenState createState() => _SecyListScreenState();
}

class _SecyListScreenState extends State<SecyListScreen> {
  @override
  bool isUserAdmin =false;
  bool isLoggedIn = false;
  final _auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection("users");

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
                                Navigator.pushNamed(context, 'secyList');
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
                          "Club List",
                          style: TextStyle(color: Colors.greenAccent, fontSize: 40),
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
                          "You Logged In As Secy",
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
                                      return ListView.builder(
                                        itemCount: documents.length,
                                        itemBuilder: (context, index){
                                          return Padding(
                                            padding: EdgeInsets.only(top:10.0),
                                            child: Card(
                                              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                                              child: ListTile(

                                                hoverColor: Colors.greenAccent,
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SecyVideo(clubName: documents[index]['Club_Name'],)));
                                                },
                                                leading: CircleAvatar(
                                                  radius: 15.0,
                                                  backgroundImage: AssetImage("${documents[index]['Club_Name']}.png"),

                                                ),
                                                title: Center(
                                                  child: Text(
                                                    documents[index]['Club_Name'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w900
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                decoration: BoxDecoration(
                                    color: null,
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                              ),
                            ],
                          ),

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
