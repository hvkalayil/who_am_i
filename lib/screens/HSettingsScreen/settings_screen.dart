import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoami/screens/BLoginRegisterScreen/login_register_screen.dart';
import 'package:whoami/screens/DRegisterScreen/registration_screen.dart';
import 'package:whoami/service/ads.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';
import 'sign_up_screen.dart';

class SettingsScreen extends StatefulWidget {
  static String id = 'Settings Screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  InterstitialAd myInterstitial;

  InterstitialAd buildInterstitialAd() {
    String myAdId = 'ca-app-pub-6276155927126955/1551459743';
    return InterstitialAd(
      adUnitId: useTestId ? InterstitialAd.testAdUnitId : myAdId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  void showInterstitialAd() {
    myInterstitial..show();
  }

  void showRandomInterstitialAd() {
    Random r = new Random();
    bool value = r.nextBool();

    if (value == true) {
      myInterstitial..show();
    }
  }

  @override
  void initState() {
    super.initState();
    initJobs();
    myInterstitial = buildInterstitialAd()..load();
  }

  @override
  void dispose() {
    myInterstitial.dispose();
    super.dispose();
  }


  bool isSignUpDone = false;
  bool confirm;
  initJobs() async {
    String x = await SharedPrefUtils.readPrefStr('isSignUpDone');
    if (x == 'yes') {
      setState(() {
        isSignUpDone = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        leading: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: secondaryColor,
              size: 40,
            )),
        title: Text('Settings', style: font.copyWith(fontSize: 28)),
        backgroundColor: primaryColor,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: <Widget>[
              makeOptions(
                  context: context, ico: Icons.edit, txt: 'Edit Details'),
              makeDivider(),
              makeOptions(
                  context: context,
                  ico: Icons.cloud_upload,
                  txt: 'Upload to cloud'),
              makeDivider(),
//              makeOptions(
//                  context: context,
//                  ico: Icons.smoke_free,
//                  txt: 'Get Ad free version'),
//              makeDivider(),
              makeOptions(
                  context: context, ico: Icons.bug_report, txt: 'Report bug'),
              makeDivider(),
              makeOptions(
                  context: context, ico: Icons.contact_mail, txt: 'Contact me'),
              makeDivider(),
              makeOptions(context: context, ico: Icons.info, txt: 'About App'),
              makeDivider(),
              isSignUpDone
                  ? makeOptions(
                      context: context,
                      ico: FontAwesomeIcons.powerOff,
                      txt: 'Log Out')
                  : SizedBox(
                      width: 0,
                    ),
              isSignUpDone
                  ? makeDivider()
                  : SizedBox(
                      width: 0,
                    ),
              SizedBox(height: 150),
             BannerAdPage()
            ],
          ),
        ),
      ),
    );
  }

  makeOptions({BuildContext context, IconData ico, String txt}) {
    return FlatButton(
      onPressed: () async {
        showRandomInterstitialAd();
        if (txt == 'Edit Details')
          Navigator.popAndPushNamed(context, RegistrationScreen.id);
        else if (txt == 'Upload to cloud') {
          Navigator.popAndPushNamed(context, SignUpScreen.id);
        }

        //Bug Report
        else if (txt == 'Report bug') {
          var url = 'mailto:hoseakalayil@gmail.com?'
              'subject=Who Am I - User Bug Report'
              '&body=Hey,<br>Bug Found:<br><br>'
              'Steps to reproduce bug:';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }

        //Contact
        else if (txt == 'Contact me') {
          var url =
              'mailto:hoseakalayil@gmail.com?subject=Who Am I - User Message'
              '&body=Hey,<br>How\'s it going?';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }

        //About App
        else if (txt == 'About App') {
          showAboutDialog(
              context: context,
              applicationName: 'Who Am I?',
              applicationVersion: 'Version 1.0',
              children: [
                Text('This is a simple app that you can use to store personal '
                    'details and files both online and offline. Users '
                    'privacy is given most precedence, so the data is '
                    'encrypted before storing in the cloud.')
              ]);
        }

        //Log Out
        else if (txt == 'Log Out') {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Confirm Log Out'),
                    content: Text('Are you sure you want to Log Out'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          await SharedPrefUtils.clearAll();
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoginRegisterScreen.id,
                              (Route<dynamic> route) => false);
                        },
                      ),
                    ],
                  ));
        }

      },
      child: ListTile(
        leading: Icon(
          ico,
          color: primaryColor,
          size: 30,
        ),
        title: Text(
          txt,
          style: font.copyWith(color: primaryColor, fontSize: 30),
        ),
      ),
    );
  }
}
