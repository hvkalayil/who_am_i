import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whoami/screens/CLoginScreen/login_screen.dart';
import 'package:whoami/screens/DRegisterScreen/registration_screen.dart';
import 'package:whoami/screens/InfoSliderScreen/info_screen.dart';
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
        backgroundColor: Color(0xff6CD2FF),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarColor: Color(0xff6CD2FF)),
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      buildAnimatedContainer(context, 'Use an existing\nProfile',
                          MyFlutterApp.icon, moveCardTop),
                      buildAnimatedContainer(context, 'Create a new\nProfile',
                          MyFlutterApp.icon2, moveCardBottom),
                      GestureDetector(
                        onTap: () => Navigator.popAndPushNamed(context, InfoScreen.id),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Show Introduction',style: font.copyWith(color: secondaryColor,fontSize: 20),),
                            SizedBox(width: 10),
                            Icon(
                              FontAwesomeIcons.lightbulb,
                              size: 30,
                              color: secondaryColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildAnimatedContainer(
      BuildContext context, String text, IconData ico, double movement) {
    return AnimatedContainer(
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(milliseconds: 600),
      transform: Matrix4.translationValues(movement, 0, 0),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
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
