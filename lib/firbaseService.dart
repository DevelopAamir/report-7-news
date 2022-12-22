import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:report7news/core/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'core/app_bootstrap.dart';
import 'core/repositories/auth_repo.dart';

class FirebaseService {
  String loggedinUser = '';
  final googleSignin = GoogleSignIn();
  GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  String name;
  String address = '';
  String photo = '';
  String phoneNumber = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  ////This is the function to fetch user data.
  getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedinUser = user.email.toString();
        name = user.displayName.toString();
        photo = user.photoURL.toString();
        phoneNumber = user.phoneNumber.toString();
        print(phoneNumber);
      }
    } catch (e) {
      print(e);
    }
  }

  ///This is the function to for googlelogin and to store data to database about user.
  Future googlelogin(context) async {
    try {
      print('1');
      final googleUser = await googleSignin.signIn();

      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final u = await auth.signInWithCredential(credential);

      if (u != null) {
        Provider.of<AppProvider>(context, listen: false).spinState();
        getCurrentUser();
        AuthRepo().storeData(loggedinUser);
        if (loggedinUser != null) {
          _firestore.collection(loggedinUser).doc(loggedinUser + 'Detail').set({
            'Name': name,
            'address': address,
            'phoneNumber': phoneNumber,
            'url': photo
          });

          Timer(Duration(seconds: 3), () {
            Provider.of<AppProvider>(context, listen: false).spinState();
            Fluttertoast.showToast(msg: 'Signed up');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AppBootstrap()));
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  ///This is the function to register user using email and password.
  Future<void> register(
      emailEditingController,
      passwordEditingController,
      nameEditingController,
      addressEditingController,
      context,
      phoneNumberEditingController) async {
    try {
      print(
        emailEditingController.text,
      );
      final User user = (await auth.createUserWithEmailAndPassword(
              email: emailEditingController.text.trim(),
              password: passwordEditingController.text))
          .user;

      auth.currentUser.sendEmailVerification().then((value) {
        showDialog(
            context: context,
            builder: (context) => Center(
                    child: WillPopScope(
                  onWillPop: () async {
                    await auth.currentUser.delete();
                    return true;
                  },
                  child: Scaffold(
                    body: Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Text("varification sent to your Email")),
                            SizedBox(
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: () async {
                                  if (user != null) {
                                    await auth.currentUser.reload();
                                    if (auth.currentUser.emailVerified) {
                                      getCurrentUser();
                                      AuthRepo().storeData(loggedinUser);
                                      if (loggedinUser != null) {
                                        _firestore
                                            .collection(loggedinUser)
                                            .doc(loggedinUser + 'Detail')
                                            .set({
                                          'Name': nameEditingController.text,
                                          'address':
                                              addressEditingController.text,
                                          'phoneNumber':
                                              phoneNumberEditingController.text,
                                          'url': null,
                                        });

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AppBootstrap()));
                                      }
                                      print('loggedinUser');
                                      print(loggedinUser);
                                      Fluttertoast.showToast(msg: 'Signed up');
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Email not varified');
                                      auth.currentUser.delete();
                                      Navigator.pop(context);
                                    }
                                  } else {}
                                },
                                child: Container(
                                  height: 50.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Colors.indigoAccent,
                                    color: Colors.indigo,
                                    elevation: 7.0,
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'varify',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )));
      });
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  ///This is the function for login using email and password.

  Future<void> logIn(
      emailEditingController, passwordEditingController, context) async {
    try {
      final User user = (await auth.signInWithEmailAndPassword(
              email: emailEditingController.text.trim(),
              password: passwordEditingController.text.trim()))
          .user;

      if (user != null) {
        getCurrentUser();
        print('logged in');
        AuthRepo().storeData(loggedinUser);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppBootstrap()),
        );
        Fluttertoast.showToast(msg: 'Logged in');
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  ///This is for logout.

  logout() async {
    final userid = auth.currentUser;
    try {
      if (userid.providerData[0].providerId == 'google.com') {
        await googleSignin.disconnect();
        print("disconnected");
      } else {
        await auth.signOut();
        print('logged out');
      }
    } catch (e) {
      await auth.signOut();
    }
  }

  ///This is for reset password
  resetPassword(context) {
    final controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reset Password'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              OutlinedButton(
                  onPressed: () async {
                    try {
                      await auth.sendPasswordResetEmail(
                          email: controller.text.trim());
                      controller.clear();
                      Fluttertoast.showToast(
                          msg: 'Reset password sent to your gmail');
                      Navigator.pop(context);
                    } on FirebaseException catch (e) {
                      controller.clear();
                      Fluttertoast.showToast(msg: '${e.message}');
                      Navigator.pop(context);
                    }
                  },
                  child: Text('send')),
            ],
          );
        });
  }

  updatePassword(context) {
    final controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reset Password'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green))),
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              OutlinedButton(
                  onPressed: () async {
                    try {
                      await auth.currentUser
                          .updatePassword(controller.text.trim());
                      controller.clear();
                      Fluttertoast.showToast(
                          msg: 'Password successfully reset');
                      Navigator.pop(context);
                    } on FirebaseException catch (e) {
                      controller.clear();
                      Fluttertoast.showToast(msg: '${e.message}');
                      Navigator.pop(context);
                    }
                  },
                  child: Text('update')),
            ],
          );
        });
  }
}
