import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:icons_helper/icons_helper.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/screens/AGOD/app_state.dart';
import 'package:whoami/screens/BLoginRegisterScreen/login_register_screen.dart';
import 'package:whoami/screens/HSettingsScreen/sign_up_screen.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import 'profile_image.dart';

class SavedCards extends StatefulWidget {
  static String id = 'SavedCardsId';

  @override
  _SavedCardsState createState() => _SavedCardsState();
}

class _SavedCardsState extends State<SavedCards> {
  bool isDone = false, isLogRegDone, running = true;

  Map<String, Map> allFriendsDetails = {};

  List<String> friendName = [];
  List<String> socialTitles = [];
  List<String> socialLinks = [];
  List<int> friendSocialLength = [];
  List<String> friendProfile = [];
  List<String> friendProName = [];

  http.Client httpClient = http.Client();
  List<bool> animate = [];

  final Firestore _database = Firestore.instance;

  makeImage(bool isProfile, String profile, String proName, int index) {
    return ProfileImage(
      isProfile: isProfile,
      path: profile,
      name: proName,
      index: index,
    );
  }

  Container makeListTile(int index, String name) {
    print(friendProName);
    Map details = allFriendsDetails[name];
    String profile = friendProfile[index];
    String proName = friendProName[index];
    bool isProfile = profile != def ? true : false;
    List<String> eachMedia = details['socialTitles'];
    List<String> eachLink = details['socialLinks'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: primaryColor),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              elevation: animate[index] ? 0 : 3,
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: secondaryColor,
              onPressed: () {
                setState(() {
                  animate[index] = !animate[index];
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  makeImage(isProfile, profile, proName, index),
                  Flexible(
                    child: Text(
                      name,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: font.copyWith(fontSize: 28, color: primaryColor),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      //DECLARING
                      List<String> tempFriendName = [];
                      List<String> tempSocialTitles = [];
                      List<String> tempSocialLinks = [];
                      List<String> tempProfile = [];
                      List<String> tempLength = [];
                      List<int> tempIntLength = [];
                      Map<String, Map> tempMap = allFriendsDetails;
                      List<String> _friendUID =
                          await SharedPrefUtils.readPrefStrList('friendUID');
                      _friendUID.removeAt(index);

                      //CHANGES
                      tempMap.remove(name);
                      tempMap.forEach((key, value) {
                        tempFriendName.add(key);
                        List<String> tempTitles = value['socialTitles'];
                        int i;
                        for (i = 0; i < tempTitles.length; i++)
                          tempSocialTitles.add(tempTitles[i]);

                        List<String> tempLinks = value['socialTitles'];
                        for (i = 0; i < tempLinks.length; i++)
                          tempSocialLinks.add(tempLinks[i]);

                        tempIntLength.add(tempSocialTitles.length);
                        tempProfile.add(value['profile']);
                      });

                      //SET STATE
                      tempLength =
                          tempIntLength.map((e) => e.toString()).toList();
                      await SharedPrefUtils.saveStrList(
                          'friendNames', tempFriendName);
                      await SharedPrefUtils.saveStrList(
                          'friendSocialTitles', tempSocialTitles);
                      await SharedPrefUtils.saveStrList(
                          'friendSocialLinks', tempSocialLinks);
                      await SharedPrefUtils.saveStrList(
                          'friendProfileImage', tempProfile);
                      await SharedPrefUtils.saveStrList(
                          'friendLength', tempLength);
                      await SharedPrefUtils.saveStrList(
                          'friendUID', _friendUID);

                      setState(() {
                        friendName = tempFriendName;
                        socialTitles = tempSocialTitles;
                        socialLinks = tempSocialLinks;
                        friendSocialLength = tempIntLength;
                        friendProfile = tempProfile;
                        allFriendsDetails = tempMap;
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.minusCircle,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ),
          animate[index] ? makeCardDivider() : SizedBox(),
          animate[index]
              ? Column(
                  children: eachLink
                      .asMap()
                      .entries
                      .map((e) =>
                          makeSocialList(eachMedia[e.key], eachLink[e.key]))
                      .toList(),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Container makeSocialList(String media, String link) {
    return media != def
        ? Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: RaisedButton(
              onPressed: () async {
                if (media == 'Gmail') {
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.all(20),
              color: secondaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    findSocialIcon(media),
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      media,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: font.copyWith(color: primaryColor, fontSize: 24),
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox();
  }

  IconData findSocialIcon(String media) {
    IconData ico;
    //GMAIL Checking
    if (media == 'gmail') {
      ico = Icons.mail_outline;
    }

    //TIKTOK Checking
    else if (media == 'tiktok') {
      ico = MyFlutterApp.tiktok;
    }

    //ALL OTHER MEDIAS
    else {
      String tempMedia = media.toLowerCase();
      //CHECK USER INPUT
      if (media.contains('.')) {
        tempMedia = media.split('.')[0].toLowerCase();
      }

      //CHECK IF ICON EXIST IN FA

      if (getFontAwesomeIcon(name: tempMedia) == null) {
        ico = FontAwesomeIcons.questionCircle;
      } else {
        ico = getFontAwesomeIcon(name: tempMedia);
      }
    }
    return ico;
  }

  @override
  void initState() {
    super.initState();
    initJobs();
  }

  int ind = 0;

  Future<String> createLink() async {
    String id = await SharedPrefUtils.readPrefStr('uid');
    String link = 'https://www.google.com/$id';
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://whoami.page.link',
      link: Uri.parse(link),
      androidParameters:
          AndroidParameters(packageName: 'com.hoseakalayil.whoami'),
    );
    final Uri dynamicUrl = await parameters.buildUrl();
    return dynamicUrl.toString();
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      id: SavedCards.id,
      child: Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: FlatButton(
              onPressed: () => isLogRegDone
                  ? Navigator.pop(context)
                  : Navigator.popAndPushNamed(context, LoginRegisterScreen.id),
              child: Icon(
                Icons.arrow_back,
                color: secondaryColor,
                size: 40,
              )),
          title: Text('Saved Cards', style: font.copyWith(fontSize: 28)),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarColor: primaryColor),
          child: RefreshIndicator(
              onRefresh: refreshAll,
              child: Column(
                children: [
                  isDone
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            padding: EdgeInsets.all(10),
                            color: primaryColor,
                            onPressed: () async {
                              String link = await createLink();
                              String message = '*Who Am I - App 👨🏻‍💻* \n'
                                  'This is my card ✉️ \n '
                                  'You can view my social media details here 🥳\n';
                              Share.share(message + link);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.share,
                                  color: secondaryColor,
                                ),
                                Text(
                                  'Share My Profile',
                                  style: font.copyWith(color: secondaryColor),
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  allFriendsDetails.length > 0
                      ? ListView(
                          shrinkWrap: true,
                          children: friendName
                              .asMap()
                              .entries
                              .map((e) => makeListTile(e.key, e.value))
                              .toList(),
                        )
                      : Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 40),
                            child: isDone
                                ? Text(
                                    'No profiles added yet 🚫\n'
                                    'Ask your friends to share their profiles.\n'
                                    'You can share your profile using the share button above ',
                                    textAlign: TextAlign.center,
                                    style: font.copyWith(
                                        color: primaryColor, fontSize: 28),
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        'Sign Up first🖊️\n'
                                        'After sign up you can share your profile and view your'
                                        ' friends profiles too😉',
                                        textAlign: TextAlign.center,
                                        style: font.copyWith(
                                            color: primaryColor, fontSize: 28),
                                      ),
                                      SizedBox(height: 20),
                                      RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          padding: EdgeInsets.all(20),
                                          color: primaryColor,
                                          onPressed: () =>
                                              Navigator.popAndPushNamed(
                                                  context, SignUpScreen.id),
                                          child: Text(
                                            'Sign Up now',
                                            style: font.copyWith(
                                                color: secondaryColor,
                                                fontSize: 20),
                                          )),
                                    ],
                                  ),
                          ),
                        ),
                ],
              )),
        ),
      ),
    );
  }

  Future<void> refreshAll() async {
    bool tempIsDone = await SharedPrefUtils.readPrefStr('isSignUpDone') == 'yes'
        ? true
        : false;
    bool tempRegDone =
        await SharedPrefUtils.readPrefStr('isLogRegDone') == 'yes'
            ? true
            : false;
    setState(() {
      isDone = tempIsDone;
      isLogRegDone = tempRegDone;
      running = true;
    });

    if (isDone) {
      List<String> _friendUID =
          await SharedPrefUtils.readPrefStrList('friendUID') ?? [];
      print('ihhihhihhihhihhihhihh');
      print(_friendUID);
      List<String> tempFriendName = [];
      List<String> tempSocialTitles = [];
      List<String> tempSocialLinks = [];
      List<int> tempIntLength = [];
      List<String> tempLength = [];
      List<String> tempProfile = [];
      List<String> tempProName = [];
      String tempProfileLink, tempProfileName;

      List<bool> tempAnimate = [];
      print(_friendUID);
      if (_friendUID.isNotEmpty) {
        doToast('Swipe down to refresh existing cards');
        for (int i = 0; i < _friendUID.length; i++) tempAnimate.add(false);
      }

      tempFriendName =
          await SharedPrefUtils.readPrefStrList('friendNames') ?? [];
      tempSocialTitles =
          await SharedPrefUtils.readPrefStrList('friendSocialTitles') ?? [];
      tempSocialLinks =
          await SharedPrefUtils.readPrefStrList('friendSocialLinks') ?? [];
      tempProfile =
          await SharedPrefUtils.readPrefStrList('friendProfileImage') ?? [];
      tempProName =
          await SharedPrefUtils.readPrefStrList('friendProName') ?? [];
      tempLength = await SharedPrefUtils.readPrefStrList('friendLength') ?? [];
      tempIntLength = tempLength.map((e) => int.parse(e)).toList();

      for (String _fUid in _friendUID) {
        try {
          Map details;
          await _database
              .collection('user details')
              .document(_fUid)
              .get()
              .then((value) => details = value.data);

          tempFriendName.add(details['name']);

          tempProfileLink = details['profileImageLink'] ?? def;
          tempProfileName = details['profileImageName'] ?? def;
          if (tempProfileLink == def) {
            tempProfile.add(def);
          } else {
            tempProfile.add(tempProfileLink);
            tempProName.add(tempProfileName);
          }

          for (String item in details['socialTitles'])
            tempSocialTitles.add(item);

          int counter = 0;
          for (String item in details['social']) {
            tempSocialLinks.add(item);
            counter++;
          }
          tempIntLength.add(counter);
        } catch (e) {
          doToast(e.toString());
        }
      }

      tempLength = tempIntLength.map((e) => e.toString()).toList();

      await SharedPrefUtils.saveStrList('friendNames', tempFriendName);
      await SharedPrefUtils.saveStrList('friendSocialTitles', tempSocialTitles);
      await SharedPrefUtils.saveStrList('friendSocialLinks', tempSocialLinks);
      await SharedPrefUtils.saveStrList('friendProfileImage', tempProfile);
      await SharedPrefUtils.saveStrList('friendProName', tempProName);
      await SharedPrefUtils.saveStrList('friendLength', tempLength);

      setState(() {
        friendName = tempFriendName;
        socialTitles = tempSocialTitles;
        socialLinks = tempSocialLinks;
        friendSocialLength = tempIntLength;
        friendProfile = tempProfile;
        friendProName = tempProName;
        animate = tempAnimate;
      });

      print(friendName);
      print(socialTitles);
      print(socialLinks);
      print(friendSocialLength);
      print(friendProfile);
      print(friendProName);

      makeMap();
      print(allFriendsDetails);
    }

    setState(() {
      running = false;
    });
  }

  initJobs() async {
    bool tempIsDone = await SharedPrefUtils.readPrefStr('isSignUpDone') == 'yes'
        ? true
        : false;
    bool tempRegDone =
        await SharedPrefUtils.readPrefStr('isLogRegDone') == 'yes'
            ? true
            : false;
    setState(() {
      isDone = tempIsDone;
      isLogRegDone = tempRegDone;
      running = true;
    });

    if (isDone) {
      List<String> _friendUID =
          await SharedPrefUtils.readPrefStrList('friendUID') ?? [];
      print('ihhihhihhihhihhihhihh');
      print(_friendUID);
      List<String> tempFriendName = [];
      List<String> tempSocialTitles = [];
      List<String> tempSocialLinks = [];
      List<int> tempIntLength = [];
      List<String> tempLength = [];
      List<String> tempProfile = [];
      List<String> tempProName = [];
      String tempProfileLink, tempProfileName;

      List<bool> tempAnimate = [];
      print(_friendUID);
      if (_friendUID.isNotEmpty) {
        doToast('Swipe down to refresh existing cards');
        for (int i = 0; i < _friendUID.length; i++) tempAnimate.add(false);
      }

      tempFriendName =
          await SharedPrefUtils.readPrefStrList('friendNames') ?? [];
      tempSocialTitles =
          await SharedPrefUtils.readPrefStrList('friendSocialTitles') ?? [];
      tempSocialLinks =
          await SharedPrefUtils.readPrefStrList('friendSocialLinks') ?? [];
      tempProfile =
          await SharedPrefUtils.readPrefStrList('friendProfileImage') ?? [];
      tempProName =
          await SharedPrefUtils.readPrefStrList('friendProName') ?? [];
      tempLength = await SharedPrefUtils.readPrefStrList('friendLength') ?? [];
      tempIntLength = tempLength.map((e) => int.parse(e)).toList();

      bool refresh =
          await SharedPrefUtils.readPrefStr('refresh') == 'yes' ? true : false;
      if (refresh) {
        String _fUid = _friendUID.last;
        print(_fUid);
        try {
          Map details;
          await _database
              .collection('user details')
              .document(_fUid)
              .get()
              .then((value) => details = value.data);

          tempFriendName.add(details['name']);

          tempProfileLink = details['profileImageLink'] ?? def;
          tempProfileName = details['profileImageName'] ?? def;
          if (tempProfileLink == def) {
            tempProfile.add(def);
          } else {
            tempProfile.add(tempProfileLink);
            tempProName.add(tempProfileName);
          }

          for (String item in details['socialTitles'])
            tempSocialTitles.add(item);

          int counter = 0;
          for (String item in details['social']) {
            tempSocialLinks.add(item);
            counter++;
          }
          tempIntLength.add(counter);
        } catch (e) {
          doToast(e.toString());
        }

        tempLength = tempIntLength.map((e) => e.toString()).toList();

        await SharedPrefUtils.saveStrList('friendNames', tempFriendName);
        await SharedPrefUtils.saveStrList(
            'friendSocialTitles', tempSocialTitles);
        await SharedPrefUtils.saveStrList('friendSocialLinks', tempSocialLinks);
        await SharedPrefUtils.saveStrList('friendProfileImage', tempProfile);
        await SharedPrefUtils.saveStrList('friendProName', tempProName);
        await SharedPrefUtils.saveStrList('friendLength', tempLength);
        await SharedPrefUtils.saveStr('refresh', 'no');
      }

      setState(() {
        friendName = tempFriendName;
        socialTitles = tempSocialTitles;
        socialLinks = tempSocialLinks;
        friendSocialLength = tempIntLength;
        friendProfile = tempProfile;
        friendProName = tempProName;
        animate = tempAnimate;
      });

      print(friendName);
      print(socialTitles);
      print(socialLinks);
      print(friendSocialLength);
      print(friendProfile);
      print(friendProName);

      makeMap();
      print(allFriendsDetails);
    }

    setState(() {
      running = false;
    });
  }

  makeMap() {
    int c = 0;
    print(friendProfile);
    Map<String, Map> tempAllDetails = {};
    if (friendName != []) {
      for (int i = 0; i < friendName.length; i++) {
        List<String> eachSocialLink = [];
        List<String> eachSocialTitle = [];
        for (int j = 0; j < friendSocialLength[i]; j++) {
          eachSocialLink.add(socialLinks[c]);
          eachSocialTitle.add(socialTitles[c]);
          c++;
        }
        Map secondary = {
          'socialTitles': eachSocialTitle,
          'socialLinks': eachSocialLink,
        };
        print(friendName);
        print(secondary);
        tempAllDetails.addAll({friendName[i]: secondary});
      }
      setState(() {
        allFriendsDetails = tempAllDetails;
      });
    }
  }
}
