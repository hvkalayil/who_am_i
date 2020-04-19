import 'package:flutter/material.dart';
import 'package:whoami/screens/doc_upload_screen.dart';
import 'package:whoami/screens/initial_screen.dart';
import 'package:whoami/screens/landing_screen.dart';
import 'package:whoami/screens/login_register_screen.dart';
import 'package:whoami/screens/login_screen.dart';
import 'package:whoami/screens/registration_screen.dart';
import 'package:whoami/screens/settings_screen.dart';
import 'package:whoami/screens/social_media_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        InitialScreen.id: (context) => InitialScreen(),
        LoginRegisterScreen.id: (context) => LoginRegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        SocialMediaScreen.id: (context) => SocialMediaScreen(),
        DocUploadScreen.id: (context) => DocUploadScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: InitialScreen(),
    );
  }
}
