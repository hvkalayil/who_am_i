import 'package:flutter/material.dart';
import 'package:whoami/screens/doc_upload_screen.dart';
import 'package:whoami/screens/login_register_screen.dart';
import 'package:whoami/screens/login_screen.dart';
import 'package:whoami/screens/registration_screen.dart';
import 'package:whoami/screens/social_media_setup_screen.dart';
import 'package:whoami/service/alert_dialog.dart';

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
        LoginRegisterScreen.id: (context) => LoginRegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        SocialMediaSetupScreen.id: (context) => SocialMediaSetupScreen(),
        DocUploadScreen.id: (context) => DocUploadScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: LoginRegisterScreen(),
    );
  }
}
