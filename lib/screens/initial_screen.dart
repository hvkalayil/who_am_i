import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../constants.dart';
import 'landing_screen.dart';
import 'login_register_screen.dart';

class InitialScreen extends StatefulWidget {
  static String id = 'InitialScreen';
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool isDone;

  initJobs() async {
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
    Timer(Duration(seconds: 3), () {
      if (isDone)
        Navigator.popAndPushNamed(context, LandingScreen.id);
      else
        Navigator.popAndPushNamed(context, LoginRegisterScreen.id);
    });
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
              Container(
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
