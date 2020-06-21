import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whoami/global.dart' as global;
import 'package:whoami/screens/AGOD/app_state.dart';
import 'package:whoami/screens/HSettingsScreen/sign_up_card.dart';
import 'package:whoami/screens/HSettingsScreen/upload_data_card.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';

class SignUpScreen extends StatefulWidget {
  static String id = 'SignUp Screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    initJobs();
  }

  initJobs() async {
    String isDone = await SharedPrefUtils.readPrefStr('isSignUpDone');
    if (isDone == 'yes') {
      String temp = await SharedPrefUtils.readPrefStr('uid');
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          global.uid = temp;
          global.isSignDone = true;
          global.options = 0;
        });
      });
    } else {
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          global.moveCard = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      id: SignUpScreen.id,
      child: WillPopScope(
        onWillPop: () {
          return;
        },
        child: Scaffold(
          backgroundColor: primaryColor,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(statusBarColor: primaryColor),
            child: SafeArea(
              child: Center(
                child: !global.isSignDone ? SignUpCard() : UploadDataCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
