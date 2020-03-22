import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/textField.dart';
import 'package:whoami/constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
          child: Container(
            color: primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    radius: 100,
                    child: FlatButton(
                      highlightColor: primaryColor,
                      splashColor: primaryColor,
                      onPressed: () {
                        print('object');
                      },
                      child: Hero(
                        tag: 'Register',
                        child: Icon(
                          MyFlutterApp.icon2,
                          size: 125,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: Column(
                        children: <Widget>[
                          textField(
                            text: 'Name',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          textField(
                            text: 'Job Title',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: secondaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CustomButton(
                          buttonPadding: EdgeInsets.all(0),
                          textColor: secondaryColor,
                          buttonColor: primaryColor,
                          buttonText: 'NEXT >',
                          onClick: () {
                            print('object');
                          },
                        )
                      ],
                    ),
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
