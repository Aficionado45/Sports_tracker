import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_web/sharedPreference.dart';


class AddUsers extends StatefulWidget {
  const AddUsers({Key key}) : super(key: key);

  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name, email, password, clubName, errorMess="";

  Future signUpWithEmailAndPassword() async {
    try{
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user != null?  userCredential.user: null;
    } on FirebaseAuthException catch (e){
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        setState(() {
          errorMess = 'Account already exists for that email.';
        });
      }
    } catch (e){
      print(e.toString());
      setState(() {
        errorMess = 'Somethings went wrong!! please try again!!';
      });
    }
  }

  Future<void> RegisterMember(String uid) async{
    return FirebaseFirestore.instance.collection('users').doc(uid)
        .set(
        {
          'full_name': name,
          'email': email,
          'club_name': clubName.capitalize(),
          'completed_task': [
            {
              "task_name": "",
              "video_link": "",
              "points" : 0,
            }
          ]

        }
    ).then((value) => print("User Added")).catchError((e)=>print("error: $e"));

  }
  @override


  void initState() {
    super.initState();
  }
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
                      height: 150,
                    ),
                    Text(
                      "Website Name",
                      style: TextStyle(
                        color: Color(0xFFFFFAFA),
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12,),
                      child: Text(errorMess, style: TextStyle(
                          fontSize: 16,
                          color: Colors.red
                      ),),
                    ),
                    Container(
                      //margin: EdgeInsets.fromLTRB(150, 0, 150, 0),
                      height: 50,
                      width: MediaQuery.of(context).size.height / 1.8,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        onChanged: (value) {
                          if (value.isEmpty)
                            return Null;
                          else {
                            name = value;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Full Name',
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
                      height: 20,
                    ),
                    Container(
                      //margin: EdgeInsets.fromLTRB(150, 0, 150, 0),
                      height: 50,
                      width: MediaQuery.of(context).size.height / 1.8,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.start,

                        onChanged: (value) {
                          if (value.isEmpty)
                            return Null;
                          else {
                            email = value;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
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
                      height: 20,
                    ),
                    Container(
                      //margin: EdgeInsets.fromLTRB(150, 0, 150, 0),
                      height: 50,
                      width: MediaQuery.of(context).size.height / 1.8,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        onChanged: (value) {
                          if (value.isEmpty)
                            return Null;
                          else {
                            clubName = value;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Club Name',
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
                      height: 20,
                    ),
                    Container(
                      //margin: EdgeInsets.fromLTRB(150, 0, 150, 0),
                      width: MediaQuery.of(context).size.height / 1.8,
                      height: 50,
                      child: TextField(
                        obscureText: true,
                        onChanged: (value) {
                          if (value.isEmpty)
                            return Null;
                          else {
                            password = value;
                          }
                        },

                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          hintText: 'Password',
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
                          child: const Text('Register',
                              style:
                              TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                        onPressed: () async {
                            signUpWithEmailAndPassword().then((value) {
                              print("${value.uid}");

                              if(value != null){
                                RegisterMember("${value.uid}");
                                updateMembersCount();
                                Navigator.pushNamed(context, 'clubList');
                              }
                            });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 120,
                    ),
                    Text(
                      "Sports Board IITG",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0XFFD3C48D),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                ),
              )),
        )
      ],
    );
  }

  Future<void> updateMembersCount(){
    return FirebaseFirestore.instance.collection('Club_Room').doc(clubName.capitalize())
        .update({'no_of_member': FieldValue.increment(1) })
        .then((value) => print('data updated'))
        .catchError((e)=> print("failed to update : $e"));
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

