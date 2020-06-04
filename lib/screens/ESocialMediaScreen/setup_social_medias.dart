import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/screens/ESocialMediaScreen/alert_add_profile.dart';
import 'package:whoami/screens/FDocumentUploadScreen/doc_upload_screen.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class SetupSocialMedias extends StatefulWidget {
  static String id = 'AddSocial Screen';
  @override
  _SetupSocialMediasState createState() => _SetupSocialMediasState();
}

class _SetupSocialMediasState extends State<SetupSocialMedias> {
  bool isSocialExist = false;
  List<String> socialMediaUrls = [];
  List<String> socialMediaTitles = [];

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
                            'No Profiles Added. Use Add button to add',
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
              makeButton(context, 'Add Profile'),
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
        List<String> tempTitles =
            await SharedPrefUtils.readPrefStrList('socialTitles');
        setState(() {
          socialMediaUrls = temp;
          socialMediaTitles = tempTitles;
          isSocialExist = true;
        });
      }
    }
  }

  Container makeButton(BuildContext context, String txt) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        color: secondaryColor,
        onPressed: () => addClick(context, txt),
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
              txt,
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

  addClick(BuildContext context, String txt) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertAddProfile();
        });
    Navigator.popAndPushNamed(context, SetupSocialMedias.id);
  }

  onNextClick() async {
    if (!isSocialExist) {
      socialMediaUrls.add(def);
      socialMediaTitles.add(def);
    }
    await SharedPrefUtils.saveStrList('socialTitles', socialMediaTitles);
    await SharedPrefUtils.saveStrList('socialLinks', socialMediaUrls);
    Navigator.push(
        context, SlideRoute(widget: DocUploadScreen(), begin: Offset(1, 0)));
  }

  List<ListTile> makeSocialList() {
    List<ListTile> socialMedias = [];
    int length = socialMediaUrls.length;
    for (int i = 0; i < length; i++) {
      socialMedias.add(makeTile(socialMediaUrls[i], i, socialMediaTitles[i]));
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
            socialMediaUrls.removeAt(i);
            if (socialMediaUrls.isEmpty) isSocialExist = false;
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
