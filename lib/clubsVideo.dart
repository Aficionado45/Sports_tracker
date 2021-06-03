
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'ClubListScreen.dart';
import 'addUsers.dart';
import 'utils/firebaseApi.dart';
import 'package:path/path.dart';

User loggedInUser;

class CompletedTask {
  int points;
  String Url;
  String taskName;
  String name;
  CompletedTask({this.points,this.taskName, this.Url, this.name });
}

class ClubsVideo extends StatefulWidget {
  final String clubName;

  const ClubsVideo({Key key, this.clubName}) : super(key: key);

  @override
  _ClubsVideoState createState() => _ClubsVideoState();
}

class _ClubsVideoState extends State<ClubsVideo> {
  final _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  TextEditingController points = TextEditingController();
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ClubListScreen()));
                            },
                            child: const Text("HOME"),
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                textStyle: TextStyle(fontSize: 16)),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddUsers()));
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
                              _auth.signOut();
                              Navigator.pushReplacementNamed(context, 'login');
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
                        widget.clubName,
                        style: TextStyle(color: Color(0xFFF3EFEF), fontSize: 40),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        height: 40,
                        // margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
                        child: Center(
                          child: Text(

                            "Club's Score : $pts",
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
                        width: MediaQuery.of(context).size.width / 1.4,
                        height: 40,
                         margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
                        child: Center(
                          child: Text(

                            "No of Members : $mem",
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
                        height: 370,
                        width: MediaQuery.of(context).size.width / 1.1,

                        // child:  FutureBuilder<QuerySnapshot>(
                        //     future: FirebaseFirestore.instance.collection("users").where('club_name', isEqualTo: widget.clubName).get(),
                        //     builder: (context, snapshot) {
                        //
                        //       if (snapshot.hasError) {
                        //         return Text('Something went wrong');
                        //       }
                        //
                        //       if (snapshot.connectionState == ConnectionState.waiting) {
                        //         return Center(
                        //           child: Container(
                        //             height: 25,
                        //             width: 25,
                        //             child: CircularProgressIndicator(),
                        //           ),
                        //         );
                        //       }
                        //       if(!snapshot.hasData){
                        //         return Text("No Data");
                        //       }
                        //
                        //       final List<DocumentSnapshot> documents =
                        //           snapshot.data.docs;
                        //       return ListView(
                        //           children: documents
                        //               .map((doc) {
                        //                 List<dynamic> completedTask = doc['completed_task'];
                        //                 completedTask.map((e) => )
                        //             return Card(
                        //
                        //                 child: ListTile(
                        //                   hoverColor: Colors.red,
                        //                   onTap: (){
                        //                   },
                        //                   title: Center(
                        //                     child: Text(
                        //                       doc['full_name'],
                        //                       style: TextStyle(
                        //                         color: Color(0XFF585858),
                        //                         fontSize: 16,
                        //                       ),
                        //                     ),
                        //                   ),
                        //
                        //                 ));
                        //           }
                        //           ).toList());
                        //     }),
                        decoration: BoxDecoration(
                            color: Color(0x741C1F1E),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                      SizedBox(height: 30),
                      Container(
                        //margin: EdgeInsets.fromLTRB(150, 0, 150, 0),
                        height: 50,
                        width: MediaQuery.of(context).size.height / 1.8,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.start,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: points,
                          decoration: InputDecoration(
                            hintText: 'Enter points',
                            hintStyle:
                            TextStyle(color: Color(0XFFBDBDBD), fontSize: 16),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      const Text("Please assign points to club", style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE8E8E8),
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: RaisedButton(
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF73DCDC),
                                    Color(0xFFC11ADC),
                                  ],
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(100.0))),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: const Text('Submit',
                                style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                          onPressed: () async {
                            updatepoints(int.parse(points.text));
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ClubListScreen()));
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  )),
            )),

      ],
    );
  }

  Future<void> updatepoints(int Points){
    return FirebaseFirestore.instance.collection('Club_Room').doc(widget.clubName)
        .update({'Points':Points})
        .then((value) => print('data updated'))
        .catchError((e)=> print("failed to update : $e"));
  }
}

