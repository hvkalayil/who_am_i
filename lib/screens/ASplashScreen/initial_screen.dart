import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:whoami/screens/BLoginRegisterScreen/login_register_screen.dart';
import 'package:whoami/screens/GHomeScreen/landing_screen.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';

class InitialScreen extends StatefulWidget {
  static String id = 'InitialScreen';
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool isDone;
  double moveImg = 500;

  initJobs() async {
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        moveImg = 0;
      });
    });
    Timer(Duration(seconds: 2), () {
      if (isDone)
        Navigator.popAndPushNamed(context, LandingScreen.id);
      else
        Navigator.popAndPushNamed(context, LoginRegisterScreen.id);
    });

    String temp = await SharedPrefUtils.readPrefStr('isLogRegDone');
    if (temp == 'yes')
      isDone = true;
    else
      isDone = false;
  }

  @override
  void initState() {
    super.initState();
    initJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000E18),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: Color(0xff000E18)),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                transform: Matrix4.translationValues(moveImg, 0, 0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.contain),
                ),
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.only(bottom: 10),
              ),
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
