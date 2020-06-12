import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/screens/BLoginRegisterScreen/login_register_screen.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class InfoScreen extends StatefulWidget {
  static String id = 'IntroSliders';
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {

  void onDonePress() {
    SharedPrefUtils.saveStr('showSlides', 'no');
    Navigator.popAndPushNamed(context, LoginRegisterScreen.id);
  }

  Slide makeSlide(String title,String path,String desc,String attr,String attrLink,Color color){
    return Slide(
        title: title,
        pathImage: path,
        styleTitle: font.copyWith(color: Color(0xff18476A),fontSize: 28,fontWeight: FontWeight.w900),
        backgroundColor: Color(0xffE3E4E5),
        widgetDescription: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              desc,
              textAlign: TextAlign.center,
              style: font.copyWith(color: Color(0xff18476A),fontSize: 24),),
            SizedBox(height:10),
            GestureDetector(
              child: Text(attr,
                  style: font.copyWith(
                      color: Color(0xff18476A),
                      fontSize: 8,
                      decoration: TextDecoration.underline
                  ))
              ,onTap: () => launch(attrLink),
            )
          ],
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: IntroSlider(
          slides: [
            makeSlide('Who Am I?',
                'assets/slidea.png',
                'Use this app to save all your information. '
                'So you can share and access them quickly',
                'Art from freevector.com',
                'https://www.freevector.com/smart-boy-character-vector-29399',
              Color(0xffE3E4E6),
            ),

            makeSlide('Social Medias',
                'assets/slideb.png',
                'Add your social media links.'
                    'So you can get all your social life in one place.',
                'Art from freepik.com',
                'https://www.freepik.com/free-photos-vectors/business',
              Color(0xffDFE5F3),
            ),

            makeSlide('Personal Documents',
                'assets/slidec.png',
                'Add all your personal documents.'
                    'Like your Driving License, PAN card, etc',
                'Art from freepik.com',
                'https://www.freepik.com/free-photos-vectors/people',
              Color(0xffEFCBAB),
            ),

            makeSlide('Enjoy Cloud Storage',
                'assets/slided.png',
                'You can upload your data to the cloud.'
                    ' Don\'t worry all documents are AES-encrypted before upload.',
                'Art from freepik.com',
                'https://www.freepik.com/free-photos-vectors/technology',
              Color(0xff79A1A9),
            ),
          ],
          onDonePress: onDonePress,
        ),
      ),
    );
  }
}
