import 'package:flutter/material.dart';
import 'package:whoami/screens/add_social_screen.dart';
import 'package:whoami/screens/doc_upload_screen.dart';
import 'package:whoami/screens/initial_screen.dart';
import 'package:whoami/screens/landing_screen.dart';
import 'package:whoami/screens/login_register_screen.dart';
import 'package:whoami/screens/login_screen.dart';
import 'package:whoami/screens/registration_screen.dart';
import 'package:whoami/screens/settings_screen.dart';
import 'package:whoami/screens/sign_up_screen.dart';
import 'package:whoami/screens/test_screen.dart';

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
        SignUpScreen.id: (context) => SignUpScreen(),
        LoginRegisterScreen.id: (context) => LoginRegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        DocUploadScreen.id: (context) => DocUploadScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        AddSocialScreen.id: (context) => AddSocialScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: InitialScreen(),
    );
  }
}
