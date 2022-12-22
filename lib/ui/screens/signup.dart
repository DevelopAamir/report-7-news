import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:report7news/core/app_bootstrap.dart';
import 'package:report7news/core/providers/app_provider.dart';
import 'package:provider/provider.dart';

import '../../firbaseService.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  var spin = false;
  final addressEditingController = TextEditingController();
  final nameEditingController = TextEditingController();
  final numberEditingController = TextEditingController();
  @override
  void dispose() {
    spin = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
                    child: Text(
                      'Signup',
                      style: TextStyle(
                          fontSize: 60.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 15.0, left: 20.0, right: 20.0, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailEditingController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: passwordEditingController,
                        decoration: InputDecoration(
                            labelText: 'Password ',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                        obscureText: true,
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: nameEditingController,
                        decoration: InputDecoration(
                            labelText: 'Name ',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: addressEditingController,
                        decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: numberEditingController,
                        decoration: InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          Provider.of<AppProvider>(context, listen: false)
                              .spinState();

                          FirebaseService()
                              .register(
                            emailEditingController,
                            passwordEditingController,
                            nameEditingController,
                            addressEditingController,
                            context,
                            numberEditingController,
                          )
                              .then((value) {
                            Provider.of<AppProvider>(context, listen: false)
                                .spinState();
                          });
                        },
                        child: Container(
                            height: 50.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.indigoAccent,
                              color: Colors.indigo,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Signup',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () async {
                          await FirebaseService().googlelogin(context);
                        },
                        child: Container(
                          height: 50.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.indigoAccent,
                            color: Colors.indigo,
                            elevation: 7.0,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: ImageIcon(
                                      AssetImage('assets/images/google.png'),
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Signin with Google',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          context.watch<AppProvider>().spin == true
              ? SpinKitDoubleBounce(color: Colors.indigo)
              : Container()
        ],
      ),
    );
  }
}
