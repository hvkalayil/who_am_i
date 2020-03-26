import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var buttonTextDecor = TextDecoration.none;

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
                                    labelText: 'UserName')),
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
                                )),
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
                                onClick: () {
                                  doVibrate();
                                  print('object');
                                },
                                textColor: secondaryColor,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  doVibrate();
                                  setState(() {
                                    buttonTextDecor = TextDecoration.underline;
                                  });
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontFamily: 'Bellotta',
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
}
