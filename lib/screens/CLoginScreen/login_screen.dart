import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:whoami/screens/GHomeScreen/landing_screen.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var buttonTextDecor = TextDecoration.none;
  String userName;
  String password;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
          child: Container(
            color: primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    radius: 100,
                    child: Icon(
                      MyFlutterApp.icon,
                      size: 125,
                      color: primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: Column(
                        children: <Widget>[
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
                              decoration: textFieldDecor.copyWith(
                                  labelText: 'UserName'),
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
                              obscureText: true,
                              textInputAction: TextInputAction.go,
                              textCapitalization: TextCapitalization.words,
                              cursorColor: primaryColor,
                              textAlign: TextAlign.center,
                              decoration: textFieldDecor.copyWith(
                                labelText: 'Password',
                              ),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
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
                                onTap: () {
                                  setState(() {
                                    buttonTextDecor = TextDecoration.underline;
                                  });
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
                      ),
                    ),
                  ),
                ),
              ],
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
        doToast(e.toString(), bg: primaryColor, txt: secondaryColor);
      }
    }
  }
}
