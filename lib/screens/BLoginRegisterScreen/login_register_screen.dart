import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whoami/screens/CLoginScreen/login_screen.dart';
import 'package:whoami/screens/DRegisterScreen/registration_screen.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';

import '../../constants.dart';

class LoginRegisterScreen extends StatefulWidget {
  static String id = 'LoginRegisterScreenID';
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  double moveCardTop = 2000;
  double moveCardBottom = -2000;
  double moveImg = -1000;
  @override
  void initState() {
    super.initState();
    animate();
  }

  void animate() async {
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        moveCardTop = 0;
        moveCardBottom = 0;
        moveImg = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool x =
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return x;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarColor: primaryColor),
          child: SafeArea(
            child: ListView(
              children: [
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image.asset('assets/bg.png'),
                    buildAnimatedContainer(context, 'Use an existing\nProfile',
                        MyFlutterApp.icon, moveCardTop),
                    buildAnimatedContainer(context, 'Create a new\nProfile',
                        MyFlutterApp.icon2, moveCardBottom),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildAnimatedContainer(
      BuildContext context, String text, IconData ico, double movement) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(movement, 0, 0),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: GestureDetector(
        onTap: () {
          if (text == 'Create a new\nProfile') {
            Navigator.push(context,
                SlideRoute(widget: RegistrationScreen(), begin: Offset(0, -1)));
          } else {
            Navigator.push(context,
                SlideRoute(widget: LoginScreen(), begin: Offset(0, -1)));
          }
        },
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            Text(
              text,
              textAlign: TextAlign.center,
              style: font.copyWith(
                fontSize: 28,
                color: primaryColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              ico,
              size: 80,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
