import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class SocialMediaSetupScreen extends StatefulWidget {
  static String id = 'SocialMediaSetupScreen';
  @override
  _SocialMediaSetupScreenState createState() => _SocialMediaSetupScreenState();
}

class _SocialMediaSetupScreenState extends State<SocialMediaSetupScreen> {
  String a, b, c;

  void initsss() async {
    a = await SharedPrefUtils.readPrefStr('profileImage');
    b = await SharedPrefUtils.readPrefStr('userName');
    c = await SharedPrefUtils.readPrefStr('jobTitle');
    setState(() {});
  }

  @override
  void initState() {
    initsss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: secondaryColor),
        child: SafeArea(
          child: Container(
            color: secondaryColor,
            child: Container(
              color: primaryColor,
              padding: EdgeInsets.all(40),
              child: Column(
                children: <Widget>[
                  Text(a),
                  Text(b),
                  Text(c),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
