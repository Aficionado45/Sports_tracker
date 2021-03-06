import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sports_web/adminLogin.dart';
import 'package:sports_web/sharedPreference.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  final _auth = FirebaseAuth.instance;
  String _keypassword;
  String pass;
  String eOrMess = "";
  void getauthenticated() async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection("authenticationKey").doc('admin').get();
    setState(() {
      pass = ds.get('admin');
    });
  }

  void initState() {
    getauthenticated();
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
                          onPressed: () {
                            Navigator.pushNamed(context, 'login');
                          },
                          child: const Text("LOGIN"),
                          style: TextButton.styleFrom(
                              primary: Color(0XFFD3C48D),
                              textStyle: TextStyle(fontSize: 20)),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            //Navigator.pushNamed(context,'admin'); // Chnage the navigator path to admin console
                          },
                          child: const Text("ADMIN"),
                          style: TextButton.styleFrom(
                              primary: Color(0XFFD3C48D),
                              textStyle: TextStyle(fontSize: 20)),
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
                    SizedBox(height: 30),
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
                            _keypassword = value;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter key',
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
                    eOrMess == ""? Text("Entry key for Admin or Secy portal", style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),): Text(eOrMess, style: TextStyle(
                        fontSize: 16,
                        color: Colors.red
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
                          child: const Text('Next',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                        onPressed: () async {
                          try {
                            if(_keypassword == pass){
                              setState(() {
                                HelperFunctions.saveAdminAuthSharedPreference(true);
                              });

                              Navigator.pushReplacementNamed(context, 'admin');
                            }
                            // if(_keypassword == "seCy"){
                            //   Navigator.pushNamed(context, 'secy');
                            // }
                            else{
                              setState(() {
                                eOrMess = "Permission Denied !!!";
                              });
                            }
                          } catch (e) {

                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 170,
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
  
}
