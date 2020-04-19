import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoami/screens/doc_upload_screen.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../constants.dart';

int socialAdded = 0;
List<int> socialAddedList = [];
List<String> profileList = [];
List<String> linkList = [];
List<String> formatList = [];
List<String> labelList = [];
Map<int, Map> social = Map<int, Map>();

class SocialMediaScreen extends StatefulWidget {
  static String id = 'SocailMediaScreen';
  @override
  _SocialMediaScreenState createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {
  bool isSocialExist = false;
  int fileAdded;

  @override
  void initState() {
    makeMap();
    super.initState();
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
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.underline,
                            fontSize: 36,
                            color: secondaryColor,
                            fontFamily: 'Bellotta'),
                      ),
                      Text(
                        'You can skip this step if you want.\n Use Add button below to add.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: secondaryColor,
                            fontFamily: 'Bellotta'),
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
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                                color: primaryColor.withAlpha(120),
                                fontFamily: 'Bellotta'),
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

  onNextClick() {
    List<String> socialAddedStrList =
        socialAddedList.map((i) => i.toString()).toList();
    SharedPrefUtils.saveStrList('socialAddedList', socialAddedStrList);
    SharedPrefUtils.saveStrList('profileList', profileList);
    SharedPrefUtils.saveStrList('linkList', linkList);
    SharedPrefUtils.saveStrList('formatList', formatList);
    SharedPrefUtils.saveStrList('labelList', labelList);
    doVibrate();
    Navigator.push(context,
        SlideRightRoute(widget: DocUploadScreen(), begin: Offset(1, 0)));
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
              style: TextStyle(
                  fontSize: 18, color: primaryColor, fontFamily: 'Bellotta'),
            )
          ],
        ),
      ),
    );
  }

  void addClick(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return CreateAlertDialog();
        });
    if (socialAddedList.isNotEmpty) {
      await makeMap();
      Navigator.popAndPushNamed(context, SocialMediaScreen.id);
    }
  }

  makeMap() async {
    List<String> socialAddedStrList =
        await SharedPrefUtils.readPrefStrList('socialAddedList');
    if (socialAddedStrList != null) {
      if (socialAddedStrList.length > -1) {
        List<int> socialAddedIntList =
            socialAddedStrList.map((i) => int.parse(i)).toList();
        int lastSocialAdded = socialAddedIntList.last;
        int length = socialAddedIntList.length;
        List<String> profileListTemp =
            await SharedPrefUtils.readPrefStrList('profileList');
        List<String> linkListTemp =
            await SharedPrefUtils.readPrefStrList('linkList');
        List<String> formatListTemp =
            await SharedPrefUtils.readPrefStrList('formatList');
        List<String> labelListTemp =
            await SharedPrefUtils.readPrefStrList('labelList');

        Map<int, Map> tempSocial = Map<int, Map>();
        for (int i = 0; i < length; i++) {
          tempSocial.addAll({
            socialAddedIntList[i]: {
              'profile': {'profile': profileListTemp[i]},
              'link': {'link': linkListTemp[i]},
              'format': {'format': formatListTemp[i]},
              'label': {'label': labelListTemp[i]},
            }
          });
        }
        setState(() {
          isSocialExist = true;
          social = tempSocial;
          socialAdded = lastSocialAdded + 1;
          socialAddedList = socialAddedIntList;
          profileList = profileListTemp;
          linkList = linkListTemp;
          formatList = formatListTemp;
          labelList = labelListTemp;
        });
      }
    }
  }

  makeSocialList() {
    List<ListTile> socialMedias = [];
    int length = social.length;
    for (int i = 0; i < length; i++) {
      if (social.containsKey(i))
        socialMedias.add(makeTile(social[i], i));
      else
        length++;
    }
    return socialMedias;
  }

  makeTile(Map m, int index) {
    String user = m['profile']['profile'];
    String url = m['link']['link'];
    String format = m['format']['format'];
    String label = m['label']['label'];
    if (format != noFormat) user = user.replaceAll(' ', format);

    String userLink = url + user;

    return ListTile(
      title: FlatButton(
        padding: EdgeInsets.all(10),
        color: primaryColor,
        onPressed: () async {
          if (url == 'https://www.gmail.com') {
            if (await canLaunch("mailto:$userLink")) {
              await launch("mailto:$userLink");
            }
          }
          if (await canLaunch(userLink)) {
            bool nativeLaunch = await launch(
              userLink,
              forceSafariVC: false,
              forceWebView: false,
              universalLinksOnly: true,
            );
            if (!nativeLaunch) {
              await launch(userLink, forceWebView: true, forceSafariVC: true);
            }
          } else {
            throw 'Could not launch $userLink';
          }
        },
        child: Text(
          label,
          style: TextStyle(
              color: secondaryColor, fontFamily: 'Bellotta', fontSize: 24),
        ),
      ),
      trailing: GestureDetector(
        onTap: () async {
          int listIndex = socialAddedList.indexOf(index);
          setState(() {
            social.remove(index);
            socialAddedList.removeAt(listIndex);
            profileList.removeAt(listIndex);
            linkList.removeAt(listIndex);
            formatList.removeAt(listIndex);
            labelList.removeAt(listIndex);
            if (social.isEmpty) isSocialExist = false;
          });
          List<String> socialAddedStrList =
              socialAddedList.map((i) => i.toString()).toList();
          await SharedPrefUtils.saveStrList(
              'socialAddedList', socialAddedStrList);
          await SharedPrefUtils.saveStrList('profileList', profileList);
          await SharedPrefUtils.saveStrList('linkList', linkList);
          await SharedPrefUtils.saveStrList('formatList', formatList);
          await SharedPrefUtils.saveStrList('labelList', labelList);
          await makeMap();
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
        ico: MyFlutterApp.tiktok,
        txt: 'Pinterest',
        link: 'https://in.pinterest.com/',
        format: noFormat));
    iconSets.add(makeSingleIcons(
        ico: MyFlutterApp.tiktok,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Social Media Profile',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: primaryColor, fontFamily: 'Bellotta', fontSize: 24),
      ),
      contentTextStyle:
          TextStyle(color: primaryColor, fontFamily: 'Bellotta', fontSize: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Social Media'),
              DropdownButton(
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
          child: Text(
            'Cancel',
            style: TextStyle(
                color: Colors.red, fontFamily: 'Bellotta', fontSize: 20),
          ),
        ),
        FlatButton(
          onPressed: () async {
            if (profile == '' || profile == null) {
              doToast('Please enter user name');
              return;
            } else {
              setState(() {
                socialAddedList.add(socialAdded);
                profileList.add(profile);
                linkList.add(url);
                formatList.add(form);
                labelList.add(label);
                socialAdded++;
              });

              List<String> socialAddedStrList =
                  socialAddedList.map((i) => i.toString()).toList();

              await SharedPrefUtils.saveStrList(
                  'socialAddedList', socialAddedStrList);
              await SharedPrefUtils.saveStrList('profileList', profileList);
              await SharedPrefUtils.saveStrList('linkList', linkList);
              await SharedPrefUtils.saveStrList('formatList', formatList);
              await SharedPrefUtils.saveStrList('labelList', labelList);
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: Text(
            'Done!',
            style: TextStyle(
                color: primaryColor, fontFamily: 'Bellotta', fontSize: 20),
          ),
        ),
      ],
    );
  }
}
