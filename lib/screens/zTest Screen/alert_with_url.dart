import 'package:flutter/material.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/screens/ESocialMediaScreen/setup_social_medias.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import 'add_social_screen.dart';

class AlertWithUrl extends StatefulWidget {
  static String id = 'AlertWthUelID';
  @override
  _AlertWithUrlState createState() => _AlertWithUrlState();
}

class _AlertWithUrlState extends State<AlertWithUrl> {
  String mediaName, mediaLink, msg = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: <Widget>[
          Text(
            'Social Media Profile',
            textAlign: TextAlign.center,
            style: font.copyWith(color: primaryColor, fontSize: 24),
          ),
          Divider(
            color: primaryColor,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
      contentTextStyle: font.copyWith(color: primaryColor, fontSize: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              mediaName = value;
              if (medias.contains(mediaName.toLowerCase())) {
                setState(() {
                  msg = 'You can add ' +
                      mediaName +
                      ' profile without setting the link.';
                });
              } else {
                setState(() {
                  msg = '';
                });
              }
            },
            decoration:
                textFieldDecor.copyWith(labelText: 'Enter Social Media Name'),
          ),
          Text(
            msg,
            style:
                font.copyWith(fontSize: 12, color: Colors.red.withOpacity(0.5)),
          ),
          SizedBox(height: 10),
          TextField(
            onChanged: (value) {
              mediaLink = value;
            },
            decoration: msg == ''
                ? textFieldDecor.copyWith(labelText: 'Enter URL')
                : textFieldDecor.copyWith(labelText: 'Enter URL/ID'),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel',
              style: font.copyWith(color: Colors.red, fontSize: 20)),
        ),
        FlatButton(
          onPressed: () async {
            if (mediaName == '' ||
                mediaLink == '' ||
                mediaName == null ||
                mediaLink == null) {
              doToast('Please fill both fields');
              return;
            } else if (msg == '' && mediaLink.contains('http')) {
              setState(() {
                socialMeidaUrls.add(mediaLink);
              });

              await SharedPrefUtils.saveStrList('socialLinks', socialMeidaUrls);
              Navigator.of(context, rootNavigator: true).pop();
            } else {}
          },
          child: Text(
            'Done!',
            style: font.copyWith(color: primaryColor, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
