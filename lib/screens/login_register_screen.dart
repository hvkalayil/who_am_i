import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whoami/screens/login_screen.dart';
import 'package:whoami/screens/registration_screen.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';

import '../constants.dart';

class LoginRegisterScreen extends StatelessWidget {
  static String id = 'LoginRegisterScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: secondaryColor),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: FlatButton(
                  color: secondaryColor,
                  splashColor: primaryColor.withAlpha(100),
                  highlightColor: primaryColor.withAlpha(50),
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Use an existing profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40,
                            color: primaryColor,
                            fontFamily: 'Bellotta'),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Hero(
                        tag: 'Login',
                        child: Icon(
                          MyFlutterApp.icon,
                          size: 80,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  splashColor: secondaryColor.withAlpha(100),
                  highlightColor: secondaryColor.withAlpha(50),
                  color: primaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'Register',
                        child: Icon(
                          MyFlutterApp.icon2,
                          size: 80,
                          color: secondaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Set up a new\n profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40,
                            color: secondaryColor,
                            fontFamily: 'Bellotta'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
