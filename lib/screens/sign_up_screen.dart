import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  static String id = 'SignUp Screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  double progress = 800;
  bool showBar = false;
  List<String> fileNames = [];
  String uid;
  FirebaseUser user;
  StorageUploadTask _task;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://who-am-i-d8752.appspot.com');
  String id, pass;
  double moveCard = 500;
  double options = 500;
  EdgeInsetsGeometry mar = EdgeInsets.only(top: 1000);
  final _auth = FirebaseAuth.instance;
  final _database = Firestore.instance;
  List<String> downloadUrl = [];
  bool isRunning = false,
      profile = true,
      name = true,
      social = true,
      files = false,
      isSignDone = false;

  @override
  void initState() {
    super.initState();
    initJobs();
  }

  initJobs() async {
    String isDone = await SharedPrefUtils.readPrefStr('isSignUpDone');
    if (isDone == 'yes') {
      String temp = await SharedPrefUtils.readPrefStr('uid');
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          uid = temp;
          isSignDone = true;
          options = 0;
        });
      });
    } else {
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          moveCard = 0;
        });
      });
    }
  }

  checkConn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarColor: primaryColor),
          child: SafeArea(
            child: ModalProgressHUD(
              inAsyncCall: isRunning,
              color: primaryColor,
              opacity: 1,
              child: Center(
                child: !isSignDone
                    ? createSignUp(context)
                    : createOptions(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  createSignUp(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(moveCard, 0, 0),
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(milliseconds: 1500),
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: primaryColor,
                  ),
                )
              ],
            ),
            Text(
              'Sign Up',
              style: font.copyWith(fontSize: 30, color: primaryColor),
            ),
            Text(
              'To upload data to cloud.',
              style: font.copyWith(fontSize: 20, color: primaryColor),
            ),
            makeDivider(),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Material(
                    elevation: 5,
                    shadowColor: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    child: TextField(
                        onChanged: (val) {
                          id = val;
                        },
                        onSubmitted: (value) {
                          FocusScope.of(context).nextFocus();
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: primaryColor,
                        textAlign: TextAlign.center,
                        decoration:
                            textFieldDecor.copyWith(labelText: 'Email Id')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    elevation: 5,
                    shadowColor: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    child: TextField(
                        onChanged: (val) {
                          pass = val;
                        },
                        obscureText: true,
                        textInputAction: TextInputAction.go,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: primaryColor,
                        textAlign: TextAlign.center,
                        decoration: textFieldDecor.copyWith(
                          labelText: 'Password',
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              buttonPadding: EdgeInsets.all(0),
              buttonColor: primaryColor,
              buttonText: 'Sign Up',
              onClick: () async {
                bool tempCon = await checkConn();
                if (tempCon) {
                  if (id == null || pass == null)
                    doToast('Please enter all data before submitting');
                  else if (!id.contains('@') ||
                      !id.contains('.') ||
                      id.contains('@.') ||
                      id.endsWith('.'))
                    doToast('Please provide a valid Email');
                  else {
                    setState(() {
                      isRunning = true;
                    });
                    try {
                      final result = await _auth.createUserWithEmailAndPassword(
                          email: id, password: pass);
                      if (result != null) {
                        SharedPrefUtils.saveStr('isSignUpDone', 'yes');
                        setState(() {
                          user = result.user;
                          uid = user.uid;
                          isRunning = false;
                          isSignDone = true;
                          moveCard = -500;
                          options = 0;
                        });
                        await SharedPrefUtils.saveStr('uid', uid);
                      }
                    } catch (e) {
                      doToast(e.toString(),
                          bg: primaryColor, txt: secondaryColor);
                    }
                    setState(() {
                      isRunning = false;
                    });
                  }
                } else {
                  doToast('Please connect to internet and try again',
                      bg: Colors.red.shade400, txt: secondaryColor);
                }
              },
              textColor: secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  createOptions(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      transform: Matrix4.translationValues(options, 0, 0),
      child: Column(
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
                SwitchListTile(
                  activeColor: primaryColor,
                  title: Text(
                    'Profile Picture',
                    style: font.copyWith(color: primaryColor, fontSize: 20),
                  ),
                  value: profile,
                  onChanged: (v) {
                    setState(() {
                      profile = v;
                    });
                  },
                ),
                SwitchListTile(
                  activeColor: primaryColor,
                  title: Text('Name and Details',
                      style: font.copyWith(color: primaryColor, fontSize: 20)),
                  value: name,
                  onChanged: (v) {
                    setState(() {
                      name = v;
                    });
                  },
                ),
                SwitchListTile(
                  activeColor: primaryColor,
                  title: Text('Social Media Links',
                      style: font.copyWith(color: primaryColor, fontSize: 20)),
                  value: social,
                  onChanged: (v) {
                    setState(() {
                      social = v;
                    });
                  },
                ),
                SwitchListTile(
                  activeColor: primaryColor,
                  title: Text('Personal Documents',
                      style: font.copyWith(color: primaryColor, fontSize: 20)),
                  value: files,
                  onChanged: (v) {
                    setState(() {
                      files = v;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  onPressed: () async {
                    bool tempCon = await checkConn();
                    if (tempCon) {
                      setState(() {
                        progress = 0;
                        showBar = true;
                      });
                      Map<String, dynamic> details = {};

                      try {
                        if (profile) {
                          String imgPath =
                              await SharedPrefUtils.readPrefStr('profileImage');
                          if (imgPath != def) {
                            File file = File(imgPath);
                            setState(() {
                              _task = _storage
                                  .ref()
                                  .child('user/' + uid + '/' + imgPath)
                                  .putFile(file);
                            });
                            fileNames.add(basename(file.path));
                            StorageTaskSnapshot takeSnapshot =
                                await _task.onComplete;
                            String url =
                                await takeSnapshot.ref.getDownloadURL();
                            downloadUrl.add(url);
                          }
                        }
                        if (name) {
                          String name =
                              await SharedPrefUtils.readPrefStr('userName');
                          details.addAll({'name': name});
                          String job =
                              await SharedPrefUtils.readPrefStr('jobTitle');
                          if (job != null && job != def || job != ' ')
                            details.addAll({'job': job});
                        }
                        if (social) {
                          List<String> social =
                              await SharedPrefUtils.readPrefStrList(
                                  'socialLinks');
                          details.addAll({'social': social});
                        }
                        if (files) {
                          List<String> titles =
                              await SharedPrefUtils.readPrefStrList('titles');
                          details.addAll({'titles': titles});

                          if (titles[0] != def) {
                            List<String> files =
                                await SharedPrefUtils.readPrefStrList('files');

                            for (int i = 0; i < files.length; i++) {
                              fileNames.add(basename(files[i]));
                              String path = files[i];
                              if (path != def) {
                                File file = File(path);
                                setState(() {
                                  _task = _storage
                                      .ref()
                                      .child('user/' + uid + '/' + path)
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
                        }

                        details.addAll({'links': downloadUrl});
                        details.addAll({'filenames': fileNames});

                        await _database
                            .collection('user details')
                            .document(uid)
                            .setData(details);
                        await SharedPrefUtils.saveStr(
                            'isFirstTimeCloud', 'yes');
                        if (_task.isSuccessful ||
                            _task.isCanceled ||
                            _task.isComplete) {
                          setState(() {
                            progress = 800;
                            showBar = false;
                          });
                          doToast('Upload completed successfully',
                              bg: primaryColor, txt: secondaryColor);
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          showBar = false;
                          progress = 800;
                        });
                        doToast('Oops an error has occured.Try Again',
                            bg: primaryColor, txt: secondaryColor);
                        await SharedPrefUtils.saveStr('isFirstTimeCloud', 'no');
                      }
                    } else {
                      doToast('Please connect to internet and try again',
                          bg: Colors.red.shade400, txt: secondaryColor);
                    }
                  },
                  color: primaryColor,
                  textColor: secondaryColor,
                  child: Text(
                    'Upload',
                    style: font.copyWith(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          _task != null
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  transform: Matrix4.translationValues(progress, 0, 0),
                  width: 200,
                  child: StreamBuilder<StorageTaskEvent>(
                    stream: _task.events,
                    builder: (context, snapshots) {
                      var event = snapshots.data.snapshot;
                      double progressPercent = event != null
                          ? event.bytesTransferred / event.totalByteCount
                          : 0;
                      return Column(
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
                            'Uploading...',
                            style: font.copyWith(
                                color: secondaryColor, fontSize: 20),
                          )
                        ],
                      );
                    },
                  ),
                )
              : SizedBox(width: 0)
        ],
      ),
    );
  }

  makeProgressBar() {
    if (_task == null ||
        _task.isCanceled ||
        _task.isComplete ||
        _task.isSuccessful) {
      setState(() {
        showBar = false;
        progress = 200;
      });
    }
    if (_task != null) {
      if (_task.isSuccessful || _task.isComplete) {
        doToast('Upload completed successfully',
            bg: primaryColor, txt: secondaryColor);
      } else {
        return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          transform: Matrix4.translationValues(0, 0, progress),
          width: 200,
          child: StreamBuilder<StorageTaskEvent>(
            stream: _task.events,
            builder: (context, snapshots) {
              var event = snapshots.data.snapshot;
              double progressPercent = event != null
                  ? event.bytesTransferred / event.totalByteCount
                  : 0;
              return Column(
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
                    style: font.copyWith(color: secondaryColor, fontSize: 20),
                  ),
                  Text(
                    'Uploading...',
                    style: font.copyWith(color: secondaryColor, fontSize: 20),
                  )
                ],
              );
            },
          ),
        );
      }
    }
  }
}
