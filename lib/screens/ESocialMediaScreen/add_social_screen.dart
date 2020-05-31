import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoami/screens/FDocumentUploadScreen/doc_upload_screen.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';

List<String> socialMeidaUrls = [];

class AddSocialScreen extends StatefulWidget {
  static String id = 'AddSocial Screen';
  @override
  _AddSocialScreenState createState() => _AddSocialScreenState();
}

class _AddSocialScreenState extends State<AddSocialScreen> {
  bool isSocialExist = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initJobs();
  }

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
                flex: 3,
                fit: FlexFit.loose,
                child: Container(
                  color: primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Add Social Media Profiles',
                        textAlign: TextAlign.center,
                        style: font.copyWith(
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline,
                          fontSize: 36,
                          color: secondaryColor,
                        ),
                      ),
                      Text(
                        'You can skip this step if you want.\n Use Add button below to add.',
                        textAlign: TextAlign.center,
                        style: font.copyWith(
                          fontSize: 18,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //****************************************************************
              //BODY

              Flexible(
                flex: 5,
                fit: FlexFit.loose,
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: EdgeInsets.only(top: 25),
                  child: isSocialExist
                      ? ListView(children: makeSocialList())
                      : Center(
                          child: Text(
                            'No Profiles Added. Use Add buton to add',
                            textAlign: TextAlign.center,
                            style: font.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 26,
                              color: primaryColor.withAlpha(120),
                            ),
                          ),
                        ),
                ),
              ),
              makeButton(context),
              SizedBox(
                height: 20,
              ),

              //****************************************************************
              //PREVIOUS AND NEXT BUTTONS

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomButton(
                    buttonText: '< PREVIOUS',
                    onClick: () {
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
                    onClick: () {
                      onNextClick();
                    },
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
          ),
        ),
      ),
    );
  }

  initJobs() async {
    List<String> temp = await SharedPrefUtils.readPrefStrList('socialLinks');
    if (temp != null) {
      if (temp.isNotEmpty && temp[0] != def) {
        setState(() {
          socialMeidaUrls = temp;
          isSocialExist = true;
        });
      }
    }
  }

  Container makeButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        color: secondaryColor,
        onPressed: () => addClick(context),
        textTheme: ButtonTextTheme.accent,
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.add,
              color: primaryColor,
            ),
            Text(
              'Add Profile',
              style: font.copyWith(
                fontSize: 18,
                color: primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  addClick(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return CreateAlertDialog();
        });
    Navigator.popAndPushNamed(context, AddSocialScreen.id);
  }

  onNextClick() async {
    if (!isSocialExist) {
      socialMeidaUrls.add(def);
    }
    await SharedPrefUtils.saveStrList('socialLinks', socialMeidaUrls);
    Navigator.push(
        context, SlideRoute(widget: DocUploadScreen(), begin: Offset(1, 0)));
  }

  makeSocialList() {
    List<ListTile> socialMedias = [];
    int length = socialMeidaUrls.length;
    for (int i = 0; i < length; i++) {
      String media = findLabel(socialMeidaUrls[i]);
      socialMedias.add(makeTile(socialMeidaUrls[i], i, media));
    }
    return socialMedias;
  }

  makeTile(String link, int i, String label) {
    return ListTile(
      title: FlatButton(
        padding: EdgeInsets.all(10),
        color: primaryColor,
        onPressed: () async {
          if (label == 'Gmail') {
            if (await canLaunch("mailto:$link")) {
              await launch("mailto:$link");
            }
          }
          if (await canLaunch(link)) {
            bool nativeLaunch = await launch(
              link,
              forceSafariVC: false,
              forceWebView: false,
              universalLinksOnly: true,
            );
            if (!nativeLaunch) {
              await launch(link, forceWebView: true, forceSafariVC: true);
            }
          } else {
            throw 'Could not launch $link';
          }
        },
        child: Text(
          label,
          style: font.copyWith(color: secondaryColor, fontSize: 24),
        ),
      ),
      trailing: GestureDetector(
        onTap: () async {
          setState(() {
            socialMeidaUrls.removeAt(i);
            if (socialMeidaUrls.isEmpty) isSocialExist = false;
          });
        },
        child: Icon(
          Icons.cancel,
          color: Colors.red,
        ),
      ),
    );
  }
}

class CreateAlertDialog extends StatefulWidget {
  static String id = 'CreateAlertDialog';
  @override
  _CreateAlertDialogState createState() => _CreateAlertDialogState();
}

class _CreateAlertDialogState extends State<CreateAlertDialog> {
  String profile, url = 'https://www.facebook.com/', form = '.';
  Icon selectedIcon = Icon(
    MyFlutterApp.facebook,
    color: primaryColor,
  );
  String label = 'Facebook';
  makeIcons() {
    List<DropdownMenuItem> iconSets = [];
    iconSets.add(makeSingleIcons(
        ico: MyFlutterApp.facebook,
        txt: 'Facebook',
        link: 'https://www.facebook.com/',
        format: '.'));
    iconSets.add(makeSingleIcons(
        ico: MyFlutterApp.instagram,
        txt: 'Instagram',
        link: 'https://www.instagram.com/',
        format: noFormat));
    iconSets.add(makeSingleIcons(
        ico: MyFlutterApp.twitter,
        txt: 'Twitter',
        link: 'https://twitter.com/',
        format: noFormat));
    iconSets.add(makeSingleIcons(
        ico: MyFlutterApp.linkedin,
        txt: 'Linkedin',
        link: 'https://www.linkedin.com/search/results/people/?keywords=',
        format: '%20'));
    iconSets.add(makeSingleIcons(
        ico: MyFlutterApp.tiktok,
        txt: 'Tikitok',
        link: 'https://www.tiktok.com/@',
        format: noFormat));
    iconSets.add(makeSingleIcons(
        ico: MyFlutterApp.pinterest,
        txt: 'Pinterest',
        link: 'https://in.pinterest.com/',
        format: noFormat));
    iconSets.add(makeSingleIcons(
        ico: MyFlutterApp.dribbble,
        txt: 'Dribble',
        link: 'https://dribbble.com/',
        format: noFormat));
    iconSets.add(makeSingleIcons(
        ico: Icons.mail,
        txt: 'Gmail',
        link: 'https://www.gmail.com',
        format: noFormat));
    return iconSets;
  }

  makeSingleIcons({IconData ico, String txt, String link, String format}) {
    return DropdownMenuItem(
      value: {
        'icon': {'icon': ico},
        'text': {'text': txt},
        'link': {'link': link},
        'format': {'format': format},
      },
      child: Icon(ico),
    );
  }

  String hintTxt = 'Facebook';
  int selectedIndex;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//              Text('Social Media'),
              DropdownButton(
                hint: Text(
                  hintTxt,
                  style: font.copyWith(color: primaryColor, fontSize: 20),
                ),
                focusColor: primaryColor,
                iconEnabledColor: primaryColor,
                icon: selectedIcon,
                items: makeIcons(),
                onChanged: (val) {
                  Map m = val['icon'];
                  Map n = val['text'];
                  Map o = val['link'];
                  Map p = val['format'];
                  setState(() {
                    selectedIcon = Icon(
                      m['icon'],
                      color: primaryColor,
                    );
                    label = n['text'];
                    hintTxt = n['text'];
                    url = o['link'];
                    form = p['format'];
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            onChanged: (value) {
              profile = value;
            },
            decoration: textFieldDecor.copyWith(labelText: 'Enter $label id'),
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
            if (profile == '' || profile == null) {
              doToast('Please enter user name');
              return;
            } else {
              String userNameforLink = profile;
              if (form != noFormat) {
                userNameforLink.replaceAll(' ', form);
              }

              setState(() {
                socialMeidaUrls.add(url + userNameforLink);
              });

              await SharedPrefUtils.saveStrList('socialLinks', socialMeidaUrls);
              Navigator.of(context, rootNavigator: true).pop();
            }
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
