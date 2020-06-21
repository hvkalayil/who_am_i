import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:whoami/screens/AGOD/app_state.dart';
import 'package:whoami/screens/BLoginRegisterScreen/login_register_screen.dart';
import 'package:whoami/screens/GHomeScreen/landing_screen.dart';
import 'package:whoami/screens/HSettingsScreen/SavedCards/saved_cards.dart';
import 'package:whoami/screens/InfoSliderScreen/info_screen.dart';
import 'package:whoami/service/dynamic_link_service.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';

class InitialScreen extends StatefulWidget {
  static String id = 'InitialScreen';

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool isDone = false;
  double moveImg = 500;
  DynamicLinkService _linkService = DynamicLinkService();

  initJobs() async {
    Timer(Duration(seconds: 1), () {
      setState(() {
        moveImg = 0;
      });
    });

      isDone = await SharedPrefUtils.readPrefStr('isLogRegDone') == 'yes'
          ? true
          : false;
      bool showFriend = await _linkService.handleDynamicLinks();

      if (showFriend) {
        Navigator.popAndPushNamed(context, SavedCards.id);
      }
      else {
        var slides = await SharedPrefUtils.readPrefStr('showSlides') ?? 'yes';
        if (slides == 'yes') {
          Timer(Duration(seconds: 1), () {
            Navigator.popAndPushNamed(context, InfoScreen.id);
          });
        }
        Timer(Duration(seconds: 2), () {
          if (isDone)
            Navigator.popAndPushNamed(context, LandingScreen.id);
          else
            Navigator.popAndPushNamed(context, LoginRegisterScreen.id);
        });
      }
  }

  @override
  void initState() {
    super.initState();
    initJobs();
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      id: InitialScreen.id,
      child: Scaffold(
        backgroundColor: Color(0xff000E18),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarColor: Color(0xff000E18)),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  curve: Curves.bounceIn,
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
      ),
    );
  }
}
