import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  @override
  String _email;
  final _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Container(
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
          body: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Container(
                //padding: EdgeInsets.only(left: 150, right: 150, bottom: 30),
                height: 50,
                width: MediaQuery.of(context).size.height / 1.8,
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.start,
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
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
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
                      child: const Text('Send Request',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    onPressed: () {
                      _auth.sendPasswordResetEmail(email: _email);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
