import 'package:flutter/material.dart';
import 'package:whoami/screens/doc_upload_screen.dart';
import 'package:whoami/screens/landing_screen.dart';
import 'package:whoami/screens/login_register_screen.dart';
import 'package:whoami/screens/login_screen.dart';
import 'package:whoami/screens/registration_screen.dart';
import 'package:whoami/screens/settings_screen.dart';
import 'package:whoami/screens/social_media_screen.dart';
import 'package:whoami/screens/social_media_setup_screen.dart';
import 'package:whoami/service/shared_prefs_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDone;

  @override
  void initState() {
    initJobs();
    super.initState();
  }

  initJobs() async {
    String temp = await SharedPrefUtils.readPrefStr('isLogRegDone');
    setState(() {
      if (temp == 'yes')
        isDone = true;
      else
        isDone = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginRegisterScreen.id: (context) => LoginRegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
//      SocialMediaSetupScreen.id: (context) => SocialMediaSetupScreen(),
        SocialMediaScreen.id: (context) => SocialMediaScreen(),
        DocUploadScreen.id: (context) => DocUploadScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: isDone ? LandingScreen() : LoginRegisterScreen(),
    );
  }
}
