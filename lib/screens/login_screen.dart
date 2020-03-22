import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/textField.dart';

import '../constants.dart';

class LoginScreen extends StatelessWidget {
  static String id = 'LoginScreen';
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
                    child: FlatButton(
                      highlightColor: primaryColor,
                      splashColor: primaryColor,
                      onPressed: () {
                        print('object');
                      },
                      child: Hero(
                        tag: 'Register',
                        child: Icon(
                          MyFlutterApp.icon,
                          size: 125,
                          color: primaryColor,
                        ),
                      ),
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
                          textField(
                            text: 'User Name',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          textField(
                            text: 'Password',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomButton(
                                buttonPadding: EdgeInsets.all(0),
                                buttonColor: primaryColor,
                                buttonText: 'Login',
                                onClick: () {
                                  print('object');
                                },
                                textColor: secondaryColor,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontFamily: 'Bellotta',
                                    color: primaryColor,
                                    fontSize: 16),
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
