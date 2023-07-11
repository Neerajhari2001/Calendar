import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/authentication.dart';
import 'package:myapp/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './homepage.dart';
import './create-group.dart';
import './add-event.dart';
import 'package:table_calendar/table_calendar.dart';
import './NavBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return Container(
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    48 * fem, 107 * fem, 0 * fem, 178 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff1da1f2),
                  borderRadius: BorderRadius.circular(20 * fem),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          19 * fem, 0 * fem, 0 * fem, 128 * fem),
                      width: 311 * fem,
                      height: 205 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 311 * fem,
                                height: 39 * fem,
                                child: Text(
                                  'CALENDAR APP',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 45 * ffem,
                                    fontWeight: FontWeight.w800,
                                    height: 1.0444444444 * ffem / fem,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 71 * fem,
                            top: 29 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 131 * fem,
                                height: 176 * fem,
                                child: Image.asset(
                                  'assets/page-1/images/events-3d-icon-icon-calendar-1.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 46 * fem, 0 * fem),
                      child: ElevatedButton(
                        onPressed: signInWithGoogle,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          width: 281 * fem,
                          height: 49 * fem,
                          decoration: BoxDecoration(
                            color: Color(0xfffefdff),
                            borderRadius: BorderRadius.circular(17 * fem),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0 * fem,
                                top: 10 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 241 * fem,
                                    height: 29 * fem,
                                    child: TextButton(
                                      onPressed: signInWithGoogle,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Text(
                                        'Continue with Google',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20 * ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5 * ffem / fem,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 238 * fem,
                                top: 11 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 27 * fem,
                                    height: 27 * fem,
                                    child: Image.asset(
                                      'assets/page-1/images/google.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {}
        }

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      await GoogleSignIn().signOut();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}