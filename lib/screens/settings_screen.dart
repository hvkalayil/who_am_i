import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whoami/screens/registration_screen.dart';

import '../constants.dart';

class SettingsScreen extends StatefulWidget {
  static String id = 'Settings Screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        title: Text(
          'Settings',
          style: TextStyle(fontFamily: 'Bellotta', fontSize: 28),
        ),
        backgroundColor: primaryColor,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              makeOptions(
                  context: context, ico: Icons.edit, txt: 'Edit Details'),
              makeDivider(),
              makeOptions(ico: Icons.cloud_upload, txt: 'Upload to cloud'),
              makeDivider(),
              makeOptions(ico: Icons.smoke_free, txt: 'Get Ad free version'),
              makeDivider(),
              makeOptions(ico: Icons.bug_report, txt: 'Report bug'),
              makeDivider(),
              makeOptions(ico: Icons.contact_mail, txt: 'Contact me'),
              makeDivider(),
            ],
          ),
        ),
      ),
    );
  }
}

makeOptions({BuildContext context, IconData ico, String txt}) {
  return FlatButton(
    onPressed: () {
      if (txt == 'Edit Details')
        Navigator.popAndPushNamed(context, RegistrationScreen.id);
    },
    child: ListTile(
      leading: Icon(
        ico,
        color: primaryColor,
        size: 30,
      ),
      title: Text(
        txt,
        style: TextStyle(
            fontFamily: 'Bellotta', color: primaryColor, fontSize: 30),
      ),
    ),
  );
}
