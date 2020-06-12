import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/global.dart' as global;
import 'package:whoami/screens/HSettingsScreen/encrypt_data.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class UploadDataCard extends StatefulWidget {
  @override
  _UploadDataCardState createState() => _UploadDataCardState();
}

class _UploadDataCardState extends State<UploadDataCard> {
  bool profile = false, name = true, social = false, files = false;
  bool isProfile = false, isSocial = false, isFiles = false;
  double progress = 800;
  bool showBar = false;
  bool enabled = true;
  String statusText = 'Files are encrypted before upload 🔐';

  StorageUploadTask _task;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://who-am-i-d8752.appspot.com');
  final _database = Firestore.instance;

  List<String> fileNames = [];
  List<String> downloadUrl = [];

  String imgPath;
  List<String> socialList = [], socialTitleList = [];
  List<String> titles = [];
  List<String> filesList = [];

  @override
  void initState() {
    super.initState();
    initJobs();
  }

  bool verDone = false;
  void initJobs() async {
    String tempProfileImage = await SharedPrefUtils.readPrefStr('profileImage');
    setState(() {
      imgPath = tempProfileImage;
    });
    if (imgPath != def) {
      setState(() {
        profile = true;
        isProfile = true;
      });
    }

    List<String> tempSocial =
        await SharedPrefUtils.readPrefStrList('socialLinks');
    if (tempSocial[0] == def || tempSocial == null) {
    } else {
      List<String> tempSocialTitles =
          await SharedPrefUtils.readPrefStrList('socialTitles');
      setState(() {
        social = true;
        isSocial = true;
        socialList = tempSocial;
        socialTitleList = tempSocialTitles;
      });
    }

    List<String> tempTitles = await SharedPrefUtils.readPrefStrList('titles');
    if (tempTitles[0] == def) {
    } else {
      List<String> tempFiles = await SharedPrefUtils.readPrefStrList('files');
      setState(() {
        files = true;
        isFiles = true;
        titles = tempTitles;
        filesList = tempFiles;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(milliseconds: 500),
      transform: Matrix4.translationValues(global.options, 0, 0),
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 30,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
                Text(
                  'Choose what to upload to cloud',
                  textAlign: TextAlign.center,
                  style: font.copyWith(fontSize: 30, color: primaryColor),
                ),
                Divider(
                  color: primaryColor,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                isProfile
                    ? SwitchListTile(
                        activeColor: primaryColor,
                        title: Text(
                          'Profile Picture',
                          style:
                              font.copyWith(color: primaryColor, fontSize: 20),
                        ),
                        value: profile,
                        onChanged: (v) {
                          if(enabled) {
                            setState(() {
                              profile = v;
                            });
                          }
                        },
                      )
                    : SizedBox(
                        width: 0,
                      ),
                SwitchListTile(
                  activeColor: primaryColor,
                  title: Text('Name and Details',
                      style: font.copyWith(color: primaryColor, fontSize: 20)),
                  value: name,
                  onChanged: (v) {
                    if(enabled) {
                      setState(() {
                        name = v;
                      });
                    }
                  },
                ),
                isSocial
                    ? SwitchListTile(
                        activeColor: primaryColor,
                        title: Text('Social Media Links',
                            style: font.copyWith(
                                color: primaryColor, fontSize: 20)),
                        value: social,
                        onChanged: (v) {
                          if(enabled) {
                            setState(() {
                              social = v;
                            });
                          }
                        },
                      )
                    : SizedBox(
                        width: 0,
                      ),
                isFiles
                    ? SwitchListTile(
                        activeColor: primaryColor,
                        title: Text('Personal Documents',
                            style: font.copyWith(
                                color: primaryColor, fontSize: 20)),
                        value: files,
                        onChanged: (v) {
                          if(enabled) {
                            setState(() {
                              files = v;
                            });
                          }
                        },
                      )
                    : SizedBox(
                        width: 0,
                      ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  onPressed: () async {
                    setState(() {
                      statusText = 'Validating Internet Connection 📡';
                      enabled = false;
                    });
                    bool tempCon = await global.checkConn();
                    if (tempCon) {
                      setState(() {
                        statusText = 'Starting Encryption  🔐 & upload ⏫';
                        progress = 0;
                        showBar = true;
                        global.isRunning = true;
                      });
                      Map<String, dynamic> details = {};

                      try {
                        //PROFILE IMAGE
                        if (profile) {
                          if (imgPath != def) {
                            File file = File(EncryptData.encrypt_file(imgPath));
                            String bName = basename(file.path);
                            setState(() {
                              _task = _storage
                                  .ref()
                                  .child(
                                      'user/' + global.uid + '/images/' + bName)
                                  .putFile(file);
                            });
                            fileNames.add(bName);
                            StorageTaskSnapshot takeSnapshot =
                                await _task.onComplete;
                            String url =
                                await takeSnapshot.ref.getDownloadURL();
                            downloadUrl.add(url);
                          }
                        }

                        //NAME AND DETAILS
                        if (name) {
                          String name =
                              await SharedPrefUtils.readPrefStr('userName');
                          details.addAll({'name': name});
                          String job =
                              await SharedPrefUtils.readPrefStr('jobTitle');
                          if (job != null && job != def || job != ' ')
                            details.addAll({'job': job});
                        }

                        //SOCIAL LINKS
                        if (social) {
                          details.addAll({'social': socialList});
                          details.addAll({'socialTitles': socialTitleList});
                        }

                        //FILES AND TITLES
                        if (files) {
                          details.addAll({'titles': titles});

                          for (int i = 0; i < filesList.length; i++) {
                            String path = filesList[i];
                            if (path != def) {
                              File file = File(EncryptData.encrypt_file(path));
                              String baseName = basename(file.path);
                              fileNames.add(baseName);
                              setState(() {
                                _task = _storage
                                    .ref()
                                    .child('user/' +
                                        global.uid +
                                        '/images/' +
                                        baseName)
                                    .putFile(file);
                              });
                              StorageTaskSnapshot takeSnapshot =
                                  await _task.onComplete;
                              String url =
                                  await takeSnapshot.ref.getDownloadURL();
                              downloadUrl.add(url);
                            }
                          }
                        }

                        details.addAll({'links': downloadUrl});
                        details.addAll({'filenames': fileNames});

                        try {
                          await _database
                              .collection('user details')
                              .document(global.uid)
                              .updateData(details);
                        }  catch (e) {
                          await _database
                              .collection('user details')
                              .document(global.uid)
                              .setData(details);
                        }
                        await SharedPrefUtils.saveStr(
                            'isFirstTimeCloud', 'yes');

                        doToast('Upload completed successfully',
                            bg: primaryColor, txt: secondaryColor);
                        setState(() {
                          statusText = 'Upload Complete 😇';
                          progress = 800;
                          showBar = false;
                        });
                      } catch (e) {
                        print(e);
                        doToast('Oops an error has occured.' + e + 'Try Again',
                            bg: primaryColor, txt: secondaryColor);
                        setState(() {
                          global.isRunning = false;
                          showBar = false;
                          progress = 800;
                        });
                      }
                    }
                    else {
                      doToast('Please connect to internet and try again',
                          bg: Colors.red.shade400, txt: secondaryColor);
                    }

                    setState(() {
                      enabled = true;
                    });
                  },
                  color: primaryColor,
                  textColor: secondaryColor,
                  child: Text(
                    'Upload',
                    style: font.copyWith(fontSize: 24),
                  ),
                ),
                Text('Make sure you have verified your email.'
                    'This will help you reset your password later, if necessary.',
                    textAlign: TextAlign.center,
                    style: font.copyWith(color: primaryColor, fontSize: 12)),
              ],
            ),
          ),
          Text(
            statusText,
            style: font.copyWith(
                color: secondaryColor, fontSize: 20),
          ),
          _task != null ?Container(
                  width: 200,
                  child: StreamBuilder<StorageTaskEvent>(
                    stream: _task.events,
                    builder: (context, snapshots) {
                      var event = snapshots.data.snapshot;
                      double progressPercent = event != null
                          ? event.bytesTransferred / event.totalByteCount
                          : 0;
                      return _task != null ?
                      Column(
                        children: <Widget>[
                          _task.isPaused
                              ? FlatButton(
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: secondaryColor,
                                  ),
                                  onPressed: () {
                                    _task.resume();
                                  },
                                )
                              : FlatButton(
                                  child: Icon(
                                    Icons.pause,
                                    color: secondaryColor,
                                  ),
                                  onPressed: () {
                                    _task.pause();
                                  },
                                ),
                          LinearProgressIndicator(
                            backgroundColor: secondaryColor,
                            value: progressPercent,
                          ),
                          Text(
                            '${(progressPercent * 100).toStringAsFixed(0)}%',
                            style: font.copyWith(
                                color: secondaryColor, fontSize: 20),
                          ),
                          Text(
                            progressPercent*100 >= 100 ? 'Completed ✔️':'Uploading...',
                            style: font.copyWith(
                                color: secondaryColor, fontSize: 20),
                          )
                        ],
                      )
                      :SizedBox(width: 0);
                    },
                  ),
                )
              : SizedBox(width: 0)
        ],
      )
    );
  }
}
