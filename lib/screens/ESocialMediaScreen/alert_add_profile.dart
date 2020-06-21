import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class AlertAddProfile extends StatefulWidget {
  static String id = 'CreateAlertDialog';
  @override
  _AlertAddProfileState createState() => _AlertAddProfileState();
}

class _AlertAddProfileState extends State<AlertAddProfile> {
  String hintTxt = 'Facebook';
  String userLink = 'https://www.facebook.com/';
  String userFormat = '.';
  String profile;
  List<String> socialMediaUrls = [];
  List<String> socialMediaTitle = [];

  bool profileMode = false;

  String userProfileLink, userProfileTitle;
  @override
  void initState() {
    super.initState();
    initJobs();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //TITLE
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add using Link',
                style: font.copyWith(color: primaryColor),
              ),
              Switch.adaptive(
                  value: profileMode,
                  onChanged: (val) {
                    setState(() {
                      profileMode = val;
                    });
                  })
            ],
          )
        ],
      ),

      //CONTENT
      contentTextStyle: font.copyWith(color: primaryColor, fontSize: 20),
      content: SingleChildScrollView(
        child: profileMode
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: TextEditingController(text: userProfileTitle),
              onChanged: (value) {
                userProfileTitle = value;
              },
              decoration:
              textFieldDecor.copyWith(labelText: 'Enter the title'),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                userProfileLink = value;
                try {
                  setState(() {
                    userProfileTitle = userProfileLink.split('/')[2];
                  });
                } catch (e) {}
              },
              decoration:
              textFieldDecor.copyWith(labelText: 'Enter the URL'),
            )
          ],
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton(
                  hint: Text(
                    hintTxt + ' ↓',
                    style: font.copyWith(color: primaryColor, fontSize: 20),
                  ),
                  focusColor: primaryColor,
                  iconEnabledColor: primaryColor,
                  icon: Icon(
                    getFontAwesomeIcon(
                        name: hintTxt.substring(0, 1).toLowerCase() +
                            hintTxt.substring(1)),
                    color: primaryColor,
                  ),
                  items: makeIcons(),
                  onChanged: (val) {
                    setState(() {
                      hintTxt = val['text'];
                      userLink = val['link'];
                      userFormat = val['format'];
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
              decoration:
              textFieldDecor.copyWith(labelText: 'Enter $hintTxt id'),
            )
          ],
        ),
      ),

      //ACTIONS
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
            if (profileMode) {
              if (userProfileLink == '' || userProfileLink == null) {
                doToast('Please add the URL');
              } else {
                if (userProfileLink.contains('http')) {
                  if (userProfileTitle == '' || userProfileTitle == null) {
                    try {
                      userProfileTitle = userProfileLink.split('/')[2];
                    } catch (e) {
                      doToast('Please enter valid URL');
                      return;
                    }
                  }
                  else if(socialMediaTitle.contains(userProfileTitle)){
                    if(socialMediaUrls[socialMediaTitle.indexOf(userProfileTitle)] == userProfileLink){
                      doToast('This profile was already added!');
                    }
                  }
                  else {
                    setState(() {
                      socialMediaUrls.add(userProfileLink);
                      socialMediaTitle.add(userProfileTitle);
                    });
                    await SharedPrefUtils.saveStrList(
                        'socialLinks', socialMediaUrls);
                    await SharedPrefUtils.saveStrList(
                        'socialTitles', socialMediaTitle);
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                } else {
                  doToast('You have to enter full URL for this to work');
                }
              }
            }
            else {
              if (profile == '' || profile == null) {
                doToast('Please enter user name');
                return;
              }
              else {
                String tempProfile = profile;
                if (userFormat != noFormat) {
                  tempProfile.replaceAll(' ', userFormat);
                }
                if(socialMediaTitle.contains(hintTxt)){
                  int index = socialMediaTitle.lastIndexOf(hintTxt);
                  if(socialMediaUrls[index].contains(tempProfile)){
                    doToast('This profile was already added!');
                  }
                }
                else {
                  setState(() {
                    socialMediaUrls.add(userLink + tempProfile);
                    socialMediaTitle.add(hintTxt);
                  });

                  await SharedPrefUtils.saveStrList(
                      'socialLinks', socialMediaUrls);
                  await SharedPrefUtils.saveStrList(
                      'socialTitles', socialMediaTitle);
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }
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

  void initJobs() async {
    List<String> temp = await SharedPrefUtils.readPrefStrList('socialLinks');
    if (temp != null) {
      if (temp.isNotEmpty && temp[0] != def) {
        List<String> tempTitles =
            await SharedPrefUtils.readPrefStrList('socialTitles');
        socialMediaUrls = temp;
        socialMediaTitle = tempTitles;
      }
    }
  }

  makeIcons() {
    List<DropdownMenuItem> iconSets = [];
    for (var ico in medias.keys) {
      iconSets.add(addEachIcon(ico, medias[ico]));
    }
    return iconSets;
  }

  DropdownMenuItem addEachIcon(
      String mediaName, Map<String, String> mediaLinks) {
    String url, format;
    for (var link in mediaLinks.keys) {
      url = link;
      format = mediaLinks[link];
    }
    String tempName =
        mediaName.substring(0, 1).toUpperCase() + mediaName.substring(1);
    IconData ic = getIconGuessFavorFA(name: mediaName);
    if (mediaName == 'gmail') {
      ic = Icons.mail_outline;
    } else if (mediaName == 'tiktok') {
      ic = MyFlutterApp.tiktok;
    }
    return DropdownMenuItem(
      value: {
        'text': mediaName,
        'link': url,
        'format': format,
      },
      child: Row(
        children: [
          Icon(ic, color: primaryColor),
          SizedBox(width: 10),
          Text(
            tempName,
            style: font.copyWith(color: primaryColor),
          )
        ],
      ),
    );
  }
}
