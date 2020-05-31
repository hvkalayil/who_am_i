import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whoami/global.dart' as global;
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';

class SignUpCard extends StatefulWidget {
  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  String id, pass;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(global.moveCard, 0, 0),
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(milliseconds: 1500),
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: primaryColor,
                  ),
                )
              ],
            ),
            Text(
              'Sign Up',
              style: font.copyWith(fontSize: 30, color: primaryColor),
            ),
            Text(
              'To upload data to cloud.',
              style: font.copyWith(fontSize: 20, color: primaryColor),
            ),
            makeDivider(),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Material(
                    elevation: 5,
                    shadowColor: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    child: TextField(
                        onChanged: (val) {
                          id = val;
                        },
                        onSubmitted: (value) {
                          FocusScope.of(context).nextFocus();
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: primaryColor,
                        textAlign: TextAlign.center,
                        decoration:
                            textFieldDecor.copyWith(labelText: 'Email Id')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    elevation: 5,
                    shadowColor: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    child: TextField(
                        onChanged: (val) {
                          pass = val;
                        },
                        obscureText: true,
                        textInputAction: TextInputAction.go,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: primaryColor,
                        textAlign: TextAlign.center,
                        decoration: textFieldDecor.copyWith(
                          labelText: 'Password',
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              buttonPadding: EdgeInsets.all(0),
              buttonColor: primaryColor,
              buttonText: 'Sign Up',
              onClick: () async {
                bool tempCon = await global.checkConn();
                if (tempCon) {
                  if (id == null || pass == null)
                    doToast('Please enter all data before submitting');
                  else if (!id.contains('@') ||
                      !id.contains('.') ||
                      id.contains('@.') ||
                      id.endsWith('.'))
                    doToast('Please provide a valid Email');
                  else {
                    setState(() {
                      global.isRunning = true;
                    });
                    try {
                      final result = await _auth.createUserWithEmailAndPassword(
                          email: id, password: pass);
                      if (result != null) {
                        SharedPrefUtils.saveStr('isSignUpDone', 'yes');
                        setState(() {
                          global.user = result.user;
                          global.uid = global.user.uid;
                          global.isRunning = false;
                          global.isSignDone = true;
                          global.moveCard = -500;
                          global.options = 0;
                        });
                        await SharedPrefUtils.saveStr('uid', global.uid);
                      }
                    } catch (e) {
                      doToast(e.toString(),
                          bg: primaryColor, txt: secondaryColor);
                    }
                    setState(() {
                      global.isRunning = false;
                    });
                  }
                } else {
                  doToast('Please connect to internet and try again',
                      bg: Colors.red.shade400, txt: secondaryColor);
                }
              },
              textColor: secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
