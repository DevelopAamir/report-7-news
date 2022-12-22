import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:report7news/core/app_bootstrap.dart';
import 'package:report7news/core/providers/app_provider.dart';
import 'package:report7news/core/repositories/auth_repo.dart';
import 'package:report7news/core/services/localstorage_service.dart';
import 'package:provider/provider.dart';

import '../../firbaseService.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  var spin = false;
  final passwordEditingController = TextEditingController();
  final emailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Container(
                      padding: EdgeInsets.only(top: 70, left: 10),
                      child: Text('Report7\nNews',
                          style: TextStyle(
                              height: 0.8,
                              fontSize: 35.0,
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
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
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                          ),
                          SizedBox(height: 20.0),
                          TextField(
                            controller: passwordEditingController,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                            obscureText: true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                FirebaseService().resetPassword(context);
                              },
                              child: Text("Forgot password?"),
                            ),
                          ),
                          SizedBox(height: 60.0),
                          GestureDetector(
                            onTap: () {
                              Provider.of<AppProvider>(context, listen: false)
                                  .spinState();
                              FirebaseService()
                                  .logIn(emailEditingController,
                                      passwordEditingController, context)
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
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25.0),
                          GestureDetector(
                            onTap: () {
                              FirebaseService().googlelogin(context);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        child: ImageIcon(
                                          AssetImage(
                                              'assets/images/google.png'),
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
                          SizedBox(height: 20.0),
                        ],
                      )),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'New to report7news ?',
                        style: TextStyle(),
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            context.watch<AppProvider>().spin == true
                ? SpinKitDoubleBounce(
                    color: Colors.indigo,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
