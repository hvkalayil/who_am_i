import 'package:flutter/material.dart';
import 'package:whoami/screens/ASplashScreen/initial_screen.dart';
import 'package:whoami/screens/BLoginRegisterScreen/login_register_screen.dart';
import 'package:whoami/screens/CLoginScreen/login_screen.dart';
import 'package:whoami/screens/DRegisterScreen/registration_screen.dart';
import 'package:whoami/screens/ESocialMediaScreen/add_social_screen.dart';
import 'package:whoami/screens/FDocumentUploadScreen/doc_upload_screen.dart';
import 'package:whoami/screens/GHomeScreen/landing_screen.dart';
import 'package:whoami/screens/HSettingsScreen/settings_screen.dart';
import 'package:whoami/screens/HSettingsScreen/sign_up_screen.dart';

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
