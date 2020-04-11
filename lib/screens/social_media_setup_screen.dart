import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/screens/doc_upload_screen.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class SocialMediaSetupScreen extends StatefulWidget {
  static String id = 'SocialMediaSetupScreen';
  @override
  _SocialMediaSetupScreenState createState() => _SocialMediaSetupScreenState();
}

class _SocialMediaSetupScreenState extends State<SocialMediaSetupScreen> {
  bool isSocialMediaAddedd = false;
  bool facebookState = true,
      instagramState = true,
      twitterState = true,
      linkedinState = true,
      tiktokState = true,
      mailState = true;
  String fbName = '',
      igName = '',
      twitterName = '',
      linkedinName = '',
      tiktokName = '',
      mailName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
            child: Column(
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              flex: 4,
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Add your Social Media Profiles',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline,
                        fontSize: 36,
                        color: secondaryColor,
                        fontFamily: 'Bellotta'),
                  ),
                  Text(
                    'You can skip this step if you want.\n Click on icons below to add them.',
                    style: TextStyle(
                        fontSize: 18,
                        color: secondaryColor,
                        fontFamily: 'Bellotta'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: addSocialMediaIconSet()),
                ],
              )),
            ),
            Flexible(
              flex: 5,
              fit: FlexFit.loose,
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: EdgeInsets.only(top: 25),
                  child: isSocialMediaAddedd
                      ? ListView(
                          children: addSocialMediaTextSet(),
                        )
                      : Center(
                          child: Text(
                            'No Social Media Seleted. Select one using the icons above.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                                color: primaryColor.withAlpha(120),
                                fontFamily: 'Bellotta'),
                          ),
                        )),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomButton(
                  buttonText: '< PREVIOUS',
                  onClick: () {
                    doVibrate();
                    Navigator.pop(context);
                  },
                  buttonColor: secondaryColor,
                  textColor: primaryColor,
                  buttonPadding: EdgeInsets.zero,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                CustomButton(
                  buttonText: 'NEXT >',
                  onClick: () => onNextClick(),
                  buttonColor: secondaryColor,
                  textColor: primaryColor,
                  buttonPadding: EdgeInsets.zero,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
              ],
            )
          ],
        )),
      ),
    );
  }

  ListTile makeTile(BuildContext context, IconData icon, String text,
      String hint, int index) {
    return ListTile(
      contentPadding: EdgeInsets.only(bottom: 15, left: 20, right: 10),
      leading: Icon(
        icon,
        size: 40,
        color: primaryColor,
      ),
      title: Material(
        elevation: 5,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
        child: TextField(
            onChanged: (value) {
              switch (index) {
                case 1:
                  {
                    fbName = value;
                    break;
                  }
                case 2:
                  {
                    igName = value;
                    break;
                  }
                case 3:
                  {
                    twitterName = value;
                    break;
                  }
                case 4:
                  {
                    linkedinName = value;
                    break;
                  }
                case 5:
                  {
                    tiktokName = value;
                    break;
                  }
                case 6:
                  {
                    mailName = value;
                  }
              }
            },
            onSubmitted: (value) {
              FocusScope.of(context).nextFocus();
            },
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            cursorColor: primaryColor,
            textAlign: TextAlign.start,
            decoration:
                textFieldDecor.copyWith(labelText: text, hintText: hint)),
      ),
      trailing: GestureDetector(
        onTap: () {
          switch (index) {
            case 1:
              {
                setState(() {
                  facebookState = !facebookState;
                  fbName = '';
                });
                break;
              }
            case 2:
              {
                setState(() {
                  instagramState = !instagramState;
                  igName = '';
                });
                break;
              }
            case 3:
              {
                setState(() {
                  twitterState = !twitterState;
                  twitterName = '';
                });
                break;
              }
            case 4:
              {
                setState(() {
                  linkedinState = !linkedinState;
                  linkedinName = '';
                });
                break;
              }
            case 5:
              {
                setState(() {
                  tiktokState = !tiktokState;
                  tiktokName = '';
                });
                break;
              }
            case 6:
              {
                setState(() {
                  mailState = !mailState;
                  mailName = '';
                });
              }
          }
          if (facebookState &&
              instagramState &&
              twitterState &&
              linkedinState &&
              tiktokState &&
              mailState) isSocialMediaAddedd = false;
        },
        child: Icon(
          Icons.do_not_disturb_on,
          color: Colors.red,
        ),
      ),
    );
  }

  addSocialMediaIconItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 1:
            {
              setState(() {
                facebookState = !facebookState;
                isSocialMediaAddedd = true;
              });
              break;
            }
          case 2:
            {
              setState(() {
                instagramState = !instagramState;
                isSocialMediaAddedd = true;
              });
              break;
            }
          case 3:
            {
              setState(() {
                twitterState = !twitterState;
                isSocialMediaAddedd = true;
              });
              break;
            }
          case 4:
            {
              setState(() {
                linkedinState = !linkedinState;
                isSocialMediaAddedd = true;
              });
              break;
            }
          case 5:
            {
              setState(() {
                tiktokState = !tiktokState;
                isSocialMediaAddedd = true;
              });
              break;
            }
          case 6:
            {
              setState(() {
                mailState = !mailState;
                isSocialMediaAddedd = true;
              });
            }
        }
      },
      child: Icon(icon, size: 30, color: secondaryColor),
    );
  }

  List<Widget> addSocialMediaIconSet() {
    List<Widget> socialMediaIcons = [];
    if (facebookState)
      socialMediaIcons.add(addSocialMediaIconItem(MyFlutterApp.facebook, 1));
    if (instagramState)
      socialMediaIcons.add(addSocialMediaIconItem(MyFlutterApp.instagram, 2));
    if (twitterState)
      socialMediaIcons.add(addSocialMediaIconItem(MyFlutterApp.twitter, 3));
    if (linkedinState)
      socialMediaIcons.add(addSocialMediaIconItem(MyFlutterApp.linkedin, 4));
    if (tiktokState)
      socialMediaIcons.add(addSocialMediaIconItem(MyFlutterApp.tiktok, 5));
    if (mailState)
      socialMediaIcons.add(addSocialMediaIconItem(Icons.mail_outline, 6));

    return socialMediaIcons;
  }

  List<Widget> addSocialMediaTextSet() {
    List<Widget> socialMediaTextSet = [];
    if (!facebookState)
      socialMediaTextSet.add(makeTile(context, MyFlutterApp.facebook,
          'Facebook', 'Enter your User Name', 1));
    if (!instagramState)
      socialMediaTextSet.add(makeTile(context, MyFlutterApp.instagram,
          'Instagram', 'Enter your IG handle', 2));
    if (!twitterState)
      socialMediaTextSet.add(makeTile(context, MyFlutterApp.twitter, 'Twitter',
          'Enter your Twitter handle', 3));
    if (!linkedinState)
      socialMediaTextSet.add(makeTile(context, MyFlutterApp.linkedin,
          'LinkedIn', 'Enter your User Name', 4));
    if (!tiktokState)
      socialMediaTextSet.add(makeTile(context, MyFlutterApp.tiktok, 'Tiktok',
          'Enter your Tiktok handle', 5));
    if (!mailState)
      socialMediaTextSet.add(makeTile(
          context, Icons.mail_outline, 'Gmail', 'Enter your Gmail address', 6));

    return socialMediaTextSet;
  }

  void onNextClick() {
    //if state is false that means it is enabled

    if (fbName == '' || fbName == null)
      SharedPrefUtils.saveStr('fbName', def);
    else
      SharedPrefUtils.saveStr('fbName', fbName);

    if (igName == '' || igName == null)
      SharedPrefUtils.saveStr('igName', def);
    else
      SharedPrefUtils.saveStr('igName', igName);

    if (twitterName == '' || twitterName == null)
      SharedPrefUtils.saveStr('twitterName', def);
    else
      SharedPrefUtils.saveStr('twitterName', twitterName);

    if (linkedinName == '' || linkedinName == null)
      SharedPrefUtils.saveStr('linkedinName', def);
    else
      SharedPrefUtils.saveStr('linkedinName', linkedinName);

    if (tiktokName == '' || tiktokName == null)
      SharedPrefUtils.saveStr('tiktokName', def);
    else
      SharedPrefUtils.saveStr('tiktokName', tiktokName);

    if (mailName == '' || mailName == null)
      SharedPrefUtils.saveStr('mailName', def);
    else
      SharedPrefUtils.saveStr('mailName', mailName);

    doVibrate();
    Navigator.pushNamed(context, DocUploadScreen.id);
  }
}
