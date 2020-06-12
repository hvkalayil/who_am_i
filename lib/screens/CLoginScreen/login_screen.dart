import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whoami/screens/GHomeScreen/landing_screen.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double moveCard = 500;
  bool pswd = true;
  var buttonTextDecor = TextDecoration.none;
  String userName;
  String password;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), (){
      setState(() {
        moveCard = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.bounceIn,
                    transform: Matrix4.translationValues(moveCard, 0, 0),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(FontAwesomeIcons.arrowLeft,color: primaryColor,size: 30,),
                            )
                          ],
                        ),
                        Image.asset('assets/login.png', fit: BoxFit.contain),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Material(
                              elevation: 5,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              child: TextField(
                                onSubmitted: (value) {
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                cursorColor: primaryColor,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.emailAddress,
                                decoration: textFieldDecor.copyWith(labelText: 'UserName'),
                                onChanged: (val) {
                                  userName = val;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Material(
                              elevation: 5,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              child: TextField(
                                obscureText: pswd,
                                textInputAction: TextInputAction.go,
                                textCapitalization: TextCapitalization.words,
                                cursorColor: primaryColor,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: textFieldDecor.copyWith(
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        pswd
                                            ? FontAwesomeIcons.eyeSlash
                                            : FontAwesomeIcons.eye,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          pswd = !pswd;
                                        });
                                      },
                                    )),
                                onChanged: (val) {
                                  password = val;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CustomButton(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  buttonPadding: EdgeInsets.all(0),
                                  buttonColor: primaryColor,
                                  buttonText: 'Login',
                                  onClick: () async {
                                    await onLoginClick();
                                  },
                                  textColor: secondaryColor,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (userName == null)
                                      doToast('Please enter the user name');
                                    else if (!userName.contains('@') ||
                                        !userName.contains('.') ||
                                        userName.contains('@.') ||
                                        userName.contains('.C') ||
                                        userName.endsWith('.'))
                                      doToast('Please provide a valid Email');
                                    else {
                                      setState(() {
                                        buttonTextDecor = TextDecoration.underline;
                                      });
                                      doToast(
                                          'A password reset email will be sent to $userName if it was verified.');
                                      await _auth.sendPasswordResetEmail(email: userName);
                                    }
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: font.copyWith(
                                        color: primaryColor,
                                        fontSize: 16,
                                        decoration: buttonTextDecor),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onLoginClick() async {
    if (userName == null || password == null)
      doToast('Please enter all data before submitting');
    else if (!userName.contains('@') ||
        !userName.contains('.') ||
        userName.contains('@.') ||
        userName.contains('.C') ||
        userName.endsWith('.'))
      doToast('Please provide a valid Email');
    else {
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: userName, password: password);
        if (user != null) {
          await SharedPrefUtils.saveStr('uid', user.user.uid);
          await SharedPrefUtils.saveStr('isSignUpDone', 'yes');
          await SharedPrefUtils.saveStr('isFirstTimeCloud', 'yes');
          Navigator.pushNamedAndRemoveUntil(
              context, LandingScreen.id, (Route<dynamic> route) => false);
        }
      } catch (e) {
        doToast(e.toString().split(',')[1],
            bg: primaryColor, txt: secondaryColor);
      }
    }
  }
}
