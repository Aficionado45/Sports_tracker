import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'utils/firebaseApi.dart';
import 'package:path/path.dart';

User loggedInUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  final _auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection("users");
  String name, club, uid;
  File file;
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

  Future<void> userdata() async {
    final uid = loggedInUser.uid;
    DocumentSnapshot ds = await userCollection.doc(uid).get();
    name = ds.get('full_name');
    club = ds.get('club_name');
  }

  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file.path) : 'No File Selected';
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
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: userdata(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Text("Loading");
                        return Text(
                          "$name | $club",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0XFFD3C48D),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                  ],
                ),
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
                      child: Text(
                        "Description Text for Instruction and Rules",
                        style: TextStyle(
                          color: Color(0XFF585858),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    Container(
                      height: 260,
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('Tasks')
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasData) {
                              final List<DocumentSnapshot> documents =
                                  snapshot.data.docs;
                              return ListView(
                                  children: documents
                                      .map((doc) => Card(
                                              child: ListTile(
                                            title: Text(
                                              doc['Task'],
                                              style: TextStyle(
                                                color: Color(0XFF585858),
                                                fontSize: 16,
                                              ),
                                            ),
                                            trailing: RaisedButton.icon(
                                              color: Color(0xFFE8E8E8),
                                              onPressed: () {
                                                selectFile();
                                                upload();
                                              },
                                              label: Text('Upload File',
                                                  style: TextStyle(
                                                      color: Color(0XFF585858),
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              icon: Icon(
                                                  Icons.cloud_circle_rounded),
                                            ),
                                          )))
                                      .toList());
                            }
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
            ],
          )),
        ));
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() => file = File(path));
    upload();
  }

  Future upload() async {
    if (file == null) return;
    final fileName = basename(file.path);
    final destination =
        'Tasks/$fileName'; //Filename in format of task$task_no_$ClubName_rollNo.mp4
    FirebaseApi.uploadFile(destination, file);
  }
}
